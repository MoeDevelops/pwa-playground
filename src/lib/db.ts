// import { migrate } from "drizzle-orm/libsql/migrator"
import { drizzle } from "drizzle-orm/better-sqlite3"

// import { blob, sqliteTable } from "drizzle-orm/sqlite-core"

export const DB_URL = "pwa-playground.db"

export const db = drizzle(DB_URL)

export async function runMigrations() {
  // await migrate(db, { migrationsFolder: "./drizzle" })
}
