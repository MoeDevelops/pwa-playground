import { eq } from "drizzle-orm"
import { v7 } from "uuid"
import { toBuffer, toString } from "uuid-buffer"
import { chats, db, users } from "$lib/db"
import { getUserByToken } from "$lib/db/auth"

export async function POST(event) {
  const sessionId = event.cookies.get("session_id")

  if (!sessionId) return new Response("No session id", { status: 422 })

  const user1 = await getUserByToken(sessionId)

  if (!user1) return new Response("No user with session id found", { status: 404 })

  const { username: username }: { username: string } = await event.request.json()

  const user2Result = await db.select().from(users).where(eq(users.username, username))

  if (user2Result.length !== 1) return new Response("User not found", { status: 404 })

  const user2 = user2Result[0]

  const chatId = v7()

  await db.insert(chats).values({
    id: toBuffer(chatId),
    user1: user1.id,
    user2: user2.id,
  })

  return new Response(
    JSON.stringify({
      id: chatId,
      user1: toString(user1.id),
      user2: toString(user2.id),
    }),
    { status: 201 },
  )
}
