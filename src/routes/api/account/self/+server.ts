import { eq } from "drizzle-orm"
import { toBuffer, toString } from "uuid-buffer"
import type { User } from "$lib"
import { db, tokens, users } from "$lib/db"

export async function GET(event) {
  const sessionId = event.cookies.get("session_id")

  if (!sessionId) return new Response("No session id", { status: 422 })

  const result = await db
    .select({ users })
    .from(users)
    .innerJoin(tokens, eq(users.id, tokens.userId))
    .where(eq(tokens.id, toBuffer(sessionId)))

  if (result.length !== 1) return new Response("No user with session id found", { status: 404 })

  const { users: userData } = result[0]

  const user: User = {
    id: toString(userData.id),
    username: userData.username,
  }

  return new Response(JSON.stringify(user), {
    status: 200,
  })
}
