import { getUserByToken } from "$lib/db/auth"

export async function GET(event) {
  const sessionId = event.cookies.get("session_id")

  if (!sessionId) return new Response("No session id", { status: 422 })

  const user = await getUserByToken(sessionId)

  if (!user) return new Response("No user with session id found", { status: 404 })

  return new Response(JSON.stringify(user), {
    status: 200,
  })
}
