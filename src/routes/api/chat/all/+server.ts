import { eq, or } from "drizzle-orm"
import { alias } from "drizzle-orm/sqlite-core"
import { toString } from "uuid-buffer"
import type { Chat } from "$lib"
import { chats, db, users } from "$lib/db"
import { getUserByToken } from "$lib/db/auth"

export async function GET(event) {
  const sessionId = event.cookies.get("session_id")

  if (!sessionId) return new Response("No session id", { status: 422 })

  const user = await getUserByToken(sessionId)

  if (!user) return new Response("No user with session id found", { status: 404 })

  const users1 = alias(users, "users1")
  const users2 = alias(users, "users2")

  const result = await db
    .select()
    .from(chats)
    .innerJoin(users1, eq(chats.user1, users1.id))
    .innerJoin(users2, eq(chats.user2, users2.id))
    .where(or(eq(chats.user1, user.id), eq(chats.user2, user.id)))

  const chatData: Chat[] = result.map((res) => {
    return {
      id: toString(res.chats.id),
      user1: toString(res.chats.user1),
      username1: res.users1.username,
      user2: toString(res.chats.user2),
      username2: res.users2.username,
    }
  })

  return new Response(JSON.stringify(chatData), {
    status: 200,
  })
}
