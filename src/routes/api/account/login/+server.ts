import { eq } from "drizzle-orm"
import { scrypt } from "node:crypto"
import { promisify } from "node:util"
import { v7 } from "uuid"
import { toBuffer } from "uuid-buffer"
import { db, passwords, tokens, users } from "$lib/db"

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
    .innerJoin(passwords, eq(users.id, passwords.userId))
    .where(eq(users.username, data.username))

  if (result.length !== 1) return new Response("User not found", { status: 404 })

  const { users: userData, passwords: passwordsData } = result[0]

  const hash = (await promisify((c) =>
    scrypt(
      data.password,
      passwordsData.salt,
      passwordsData.password.length,
      {
        N: passwordsData.N,
        r: passwordsData.r,
        p: passwordsData.p,
      },
      c,
    ),
  )()) as Buffer

  if (!passwordsData.password.equals(hash)) return new Response("User not found", { status: 404 })

  const sessionId = v7()

  await db.insert(tokens).values({
    id: toBuffer(sessionId),
    userId: userData.id,
  })

  const time = 31536926 // 1 Year

  return new Response("", {
    status: 200,
    headers: {
      "Set-Cookie": `session_id=${sessionId}; Path=/; Max-Age=${time}`,
    },
  })
}
