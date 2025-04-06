import { eq, or } from "drizzle-orm"
import { toString } from "uuid-buffer"
import { chats, db } from "$lib/db"
import { getUserByToken } from "$lib/db/auth"

export async function GET(event) {
  const sessionId = event.cookies.get("session_id")

  if (!sessionId) return new Response("No session id", { status: 422 })

  const user = await getUserByToken(sessionId)

  if (!user) return new Response("No user with session id found", { status: 404 })

  const result = await db
    .select()
    .from(chats)
    .where(or(eq(chats.user1, user.id), eq(chats.user2, user.id)))

  const chatData = result.map((binChat) => {
    return {
      id: toString(binChat.id),
      user1: toString(binChat.user1),
      user2: toString(binChat.user2),
    }
  })

  return new Response(JSON.stringify(chatData), {
    status: 200,
  })
}
