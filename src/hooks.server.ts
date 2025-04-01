import { building } from "$app/environment"
import { runMigrations } from "$lib/db"

if (!building) await runMigrations()
