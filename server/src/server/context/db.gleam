import gleam/result
import pog.{type Connection}
import server/env

pub fn init() -> Result(Connection, Nil) {
  use url <- result.try(env.get_database_url())
  use config <- result.try(pog.url_config(url))
  let connection = pog.connect(config)

  Ok(connection)
}
