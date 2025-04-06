import { drizzle } from "drizzle-orm/libsql"
import { migrate } from "drizzle-orm/libsql/migrator"
import { existsSync, mkdirSync } from "node:fs"
import * as schema from "./schema"

export * from "./schema"

export const DB_URL = "data/pwa-playground.db"

if (!existsSync("data/")) mkdirSync("data/")

export const db = drizzle(`file:${DB_URL}`, { schema })

export async function runMigrations() {
  await migrate(db, { migrationsFolder: "./drizzle" })
}
