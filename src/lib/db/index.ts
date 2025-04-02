import { drizzle } from "drizzle-orm/libsql"
import { migrate } from "drizzle-orm/libsql/migrator"
import { existsSync, mkdirSync } from "node:fs"

export * from "./schema"

export const DB_URL = "data/pwa-playground.db"

if (!existsSync("data/")) mkdirSync("data/")

export const db = drizzle(`file:${DB_URL}`)

export async function runMigrations() {
  await migrate(db, { migrationsFolder: "./drizzle" })
}
