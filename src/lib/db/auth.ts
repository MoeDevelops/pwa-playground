import { eq } from "drizzle-orm"
import { toBuffer, toString } from "uuid-buffer"
import type { User } from "$lib"
import { db, tokens, users } from "."

export async function getUserByToken(token: string): Promise<User | null> {
  const result = await db
    .select({ users })
    .from(users)
    .innerJoin(tokens, eq(users.id, tokens.userId))
    .where(eq(tokens.id, toBuffer(token)))

  if (result.length !== 1) return null

  const { users: user } = result[0]

  return {
    ...user,
    id: toString(user.id),
  }
}
