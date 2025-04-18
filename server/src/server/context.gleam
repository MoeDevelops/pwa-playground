import gleam/int
import gleam/io
import gleam/string
import pog.{type Connection}
import server/context/db
import server/env
import shellout

pub type Context {
  Context(db: Connection)
}

fn migrate() {
  let assert Ok(database_url) = env.get_database_url()
  let shell_result =
    shellout.command("dbmate", ["up"], ".", [
      shellout.SetEnvironment([#("DATABASE_URL", database_url)]),
    ])

  case shell_result {
    Ok("") -> Nil
    Ok(output) ->
      { "Ran migration:\n" <> output }
      |> string.trim()
      |> io.println()
    Error(#(code, output)) -> {
      let msg =
        "Error during migration: " <> int.to_string(code) <> "\n" <> output
      panic as msg
    }
  }
}

pub fn init() -> Context {
  env.read_dotenv()
  migrate()
  let assert Ok(db) = db.init()

  Context(db)
}
