import { and, eq, or } from "drizzle-orm"
import { v7 } from "uuid"
import { toBuffer, toString } from "uuid-buffer"
import type { Message } from "$lib"
import { chats, db, messages } from "$lib/db"
import { getUserByToken } from "$lib/db/auth"

export async function POST(event) {
  const sessionId = event.cookies.get("session_id")

  if (!sessionId) return new Response("No session id", { status: 422 })

  const user = await getUserByToken(sessionId)

  if (!user) return new Response("No user with session id found", { status: 404 })

  const { chat: chatId, message: messageContent }: { chat: string; message: string } =
    await event.request.json()

  if (messageContent.length <= 0 || messageContent.length >= 4000)
    return new Response("Invalid message", { status: 422 })

  const chatIdBin = toBuffer(chatId)

  const chat = await db
    .select()
    .from(chats)
    .where(and(eq(chats.id, chatIdBin), or(eq(chats.user1, user.id), eq(chats.user2, user.id))))

  if (chat.length !== 1) return new Response("Chat not found", { status: 404 })

  const messageId = v7()

  await db.insert(messages).values({
    id: toBuffer(messageId),
    chat: chatIdBin,
    author: user.id,
    content: messageContent,
  })

  const message: Message = {
    id: messageId,
    author: toString(user.id),
    authorName: user.username,
    content: messageContent,
  }

  return new Response(JSON.stringify(message), { status: 201 })
}
