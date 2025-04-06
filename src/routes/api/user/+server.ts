import { eq } from "drizzle-orm"
import { toBuffer } from "uuid-buffer"
import { binUserToUser } from "$lib"
import { db, users } from "$lib/db/index.js"

export async function GET(event) {
  const userId = event.url.searchParams.get("id")

  if (!userId) return new Response("No id", { status: 404 })

  const userData = await db
    .select()
    .from(users)
    .where(eq(users.id, toBuffer(userId)))

  if (userData.length !== 1) return new Response("No user found", { status: 404 })

  const user = binUserToUser(userData[0])

  return new Response(JSON.stringify(user), { status: 200 })
}
