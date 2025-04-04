import { blob, int, sqliteTable, text } from "drizzle-orm/sqlite-core"
import { v7 } from "uuid"
import { toBuffer } from "uuid-buffer"

export const users = sqliteTable("users", {
  id: blob({ mode: "buffer" })
    .primaryKey()
    .$defaultFn(() => toBuffer(v7())),
  username: text().notNull().unique(),
})

export const passwords = sqliteTable("passwords", {
  userId: blob({ mode: "buffer" })
    .primaryKey()
    .references(() => users.id),
  password: blob({ mode: "buffer" }).notNull(),
  salt: blob({ mode: "buffer" }).notNull(),
  N: int().notNull(),
  r: int().notNull(),
  p: int().notNull(),
})

export const tokens = sqliteTable("tokens", {
  id: blob({ mode: "buffer" })
    .primaryKey()
    .$defaultFn(() => toBuffer(v7())),
  userId: blob({ mode: "buffer" })
    .references(() => users.id)
    .notNull(),
})

export const chats = sqliteTable("chats", {
  id: blob({ mode: "buffer" })
    .primaryKey()
    .$defaultFn(() => toBuffer(v7())),
  user1: blob({ mode: "buffer" })
    .references(() => users.id)
    .notNull(),
  user2: blob({ mode: "buffer" })
    .references(() => users.id)
    .notNull(),
})

export const messages = sqliteTable("messages", {
  id: blob({ mode: "buffer" })
    .primaryKey()
    .$defaultFn(() => toBuffer(v7())),
  chat: blob({ mode: "buffer" })
    .references(() => chats.id)
    .notNull(),
  author: blob({ mode: "buffer" })
    .references(() => users.id)
    .notNull(),
  content: text().notNull(),
})
