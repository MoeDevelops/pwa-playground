import { eq } from "drizzle-orm"
import { scrypt } from "node:crypto"
import { promisify } from "node:util"
import { v7 } from "uuid"
import { toBuffer } from "uuid-buffer"
import { auth, db, tokens, users } from "$lib/db"

export type CreateAccount = {
  username: string
  password: string
}

export async function POST(event) {
  const data: CreateAccount = await event.request.json()

  if (data.username === "" || data.username.length > 16)
    return new Response("Invalid username", { status: 422 })

  const result = await db
    .select()
    .from(users)
    .innerJoin(auth, eq(users.id, auth.userId))
    .where(eq(users.username, data.username))

  if (result.length !== 1) return new Response("User not found", { status: 404 })

  const { users: userData, auth: authData } = result[0]

  const hash = (await promisify((c) =>
    scrypt(
      data.password,
      authData.salt,
      authData.password.length,
      {
        N: authData.N,
        r: authData.r,
        p: authData.p,
      },
      c,
    ),
  )()) as Buffer

  if (!authData.password.equals(hash)) return new Response("User not found", { status: 404 })

  const sessionId = v7()

  await db.insert(tokens).values({
    id: toBuffer(sessionId),
    userId: userData.id,
  })

  const time = Date.now() + 31536926 // 1 Year in the future

  return new Response("", {
    status: 200,
    headers: {
      "Set-Cookie": `session_id=${sessionId}; Path=/; Max-Age=${time}`,
    },
  })
}
