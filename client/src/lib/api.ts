import { type Result, err, ok } from "neverthrow"
import { browser, dev } from "$app/environment"
import { page } from "$app/state"
import type { Chat, Message, User } from "$lib"

const baseUrl = (() => {
  if (dev) {
    return "http://0.0.0.0:5001"
  } else if (browser) {
    return `https://api.${page.url.host}`
  } else {
    return ""
  }
})()

function getSessionId() {
  return { session_id: localStorage.getItem("session_id") ?? "" }
}

export async function postSignup(
  username: string,
  password: string,
): Promise<Result<void, string>> {
  const result = await fetch(`${baseUrl}/account/signup`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      username: username,
      password: password,
    }),
  })

  if (result.status !== 201) return err(await result.text())

  const token = await result.text()
  localStorage.setItem("session_id", token)

  return ok()
}

export async function postLogin(username: string, password: string): Promise<Result<void, string>> {
  const result = await fetch(`${baseUrl}/account/login`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      username: username,
      password: password,
    }),
  })

  if (result.status !== 200) return err(await result.text())

  const token = await result.text()
  localStorage.setItem("session_id", token)

  return ok()
}

export async function getChats(): Promise<Result<Chat[], void>> {
  const result = await fetch(`${baseUrl}/chat/all`, {
    method: "GET",
    headers: {
      ...getSessionId(),
    },
  })

  if (result.status !== 200) return err()

  const chats: Chat[] = await result.json()

  return ok(chats)
}

export async function postChat(username: string): Promise<Result<Chat, string>> {
  const result = await fetch(`${baseUrl}/chat`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      ...getSessionId(),
    },
    body: JSON.stringify({
      username: username,
    }),
  })

  if (result.status !== 201) return err(await result.text())

  const chat: Chat = await result.json()

  return ok(chat)
}

export async function getAccountSelf(): Promise<Result<User, void>> {
  const result = await fetch(`${baseUrl}/account/self`, {
    headers: {
      ...getSessionId(),
    },
  })

  if (result.status !== 200) return err()

  const user: User = await result.json()

  return ok(user)
}

export async function getMessages(id: string): Promise<Result<Message[], string>> {
  const result = await fetch(`${baseUrl}/chat/messages?id=${id}`, {
    headers: {
      ...getSessionId(),
    },
  })

  if (result.status !== 200) return err(await result.text())

  const messages: Message[] = await result.json()

  return ok(messages)
}

export async function postMessage(chatId: string, content: string) {
  const result = await fetch(`${baseUrl}/message`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      ...getSessionId(),
    },
    body: JSON.stringify({
      chat: chatId,
      message: content,
    }),
  })

  if (result.status !== 201) return err(await result.text())

  const message: Message = await result.json()

  return ok(message)
}
