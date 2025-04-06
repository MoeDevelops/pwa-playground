import { eq } from "drizzle-orm"
import { toBuffer } from "uuid-buffer"
import type { BinUser } from "$lib"
import { db, tokens, users } from "."

export async function getUserByToken(token: string): Promise<BinUser | null> {
  const result = await db
    .select({ users })
    .from(users)
    .innerJoin(tokens, eq(users.id, tokens.userId))
    .where(eq(tokens.id, toBuffer(token)))

  if (result.length !== 1) return null

  return result[0].users
}
