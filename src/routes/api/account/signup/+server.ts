import { eq } from "drizzle-orm"
import { type ScryptOptions, randomBytes, scrypt } from "node:crypto"
import { promisify } from "node:util"
import { v7 } from "uuid"
import { toBuffer } from "uuid-buffer"
import { db, passwords, tokens, users } from "$lib/db"

export type CreateAccount = {
  username: string
  password: string
}

const scryptConf: ScryptOptions = {
  N: 16384,
  r: 8,
  p: 5,
}

export async function POST(event) {
  const data: CreateAccount = await event.request.json()

  if (data.username === "" || data.username.length > 16)
    return new Response("Invalid username", { status: 422 })

  const usedUsername = await db.select().from(users).where(eq(users.username, data.username))

  if (usedUsername.length !== 0) return new Response("Username is already used", { status: 409 })

  const salt = randomBytes(16)
  const hash = (await promisify((c) => scrypt(data.password, salt, 32, scryptConf, c))()) as Buffer
  const id = v7()
  const idBin = toBuffer(id)

  await db.insert(users).values({
    id: idBin,
    username: data.username,
  })

  await db.insert(passwords).values({
    userId: idBin,
    password: hash,
    salt: salt,
    N: scryptConf.N!,
    r: scryptConf.r!,
    p: scryptConf.p!,
  })

  const sessionId = v7()

  await db.insert(tokens).values({
    id: toBuffer(sessionId),
    userId: idBin,
  })

  const time = 31536926 // 1 Year

  return new Response("", {
    status: 201,
    headers: {
      "Set-Cookie": `session_id=${sessionId}; Path=/; Max-Age=${time}`,
    },
  })
}
