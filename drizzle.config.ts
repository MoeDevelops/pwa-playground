import { defineConfig } from "drizzle-kit"
import { DB_URL } from "./src/lib/db"

export default defineConfig({
  out: "./drizzle",
  schema: "./src/lib/db/schema.ts",
  dialect: "sqlite",
  dbCredentials: { url: DB_URL },
})
