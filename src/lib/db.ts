// import { migrate } from "drizzle-orm/libsql/migrator"
import { drizzle } from "drizzle-orm/libsql/node"

// import { blob, sqliteTable } from "drizzle-orm/sqlite-core"

export const DB_URL = "pwa-playground.db"

export const db = drizzle({ connection: { url: `file:${DB_URL}` } })

export async function runMigrations() {
  // await migrate(db, { migrationsFolder: "./drizzle" })
}
