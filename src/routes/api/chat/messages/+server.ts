import { and, eq, or } from "drizzle-orm"
import { toBuffer, toString } from "uuid-buffer"
import type { Message } from "$lib"
import { getUserByToken } from "$lib/db/auth"
import { chats, db, messages, users } from "$lib/db/index.js"

export async function GET(event) {
  const chatId = event.url.searchParams.get("id")

  if (!chatId) return new Response("No chat id", { status: 422 })

  const sessionId = event.cookies.get("session_id")

  if (!sessionId) return new Response("No session id", { status: 422 })

  const user = await getUserByToken(sessionId)

  if (!user) return new Response("No user with session id found", { status: 404 })

  const chatIdBin = toBuffer(chatId)

  const chat = await db
    .select()
    .from(chats)
    .where(and(eq(chats.id, chatIdBin), or(eq(chats.user1, user.id), eq(chats.user2, user.id))))

  if (chat.length !== 1) return new Response("Chat not found", { status: 404 })

  const messagesData: Message[] = (
    await db
      .select()
      .from(messages)
      .innerJoin(users, eq(users.id, messages.author))
      .where(eq(messages.chat, chatIdBin))
  ).map((x) => {
    return {
      id: toString(x.messages.id),
      author: toString(x.users.id),
      authorName: x.users.username,
      content: x.messages.content,
    }
  })

  return new Response(JSON.stringify(messagesData), { status: 200 })
}
