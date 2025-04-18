import gleam/result
import glenvy/dotenv
import glenvy/env

pub fn read_dotenv() {
  let _ = dotenv.load()
  Nil
}

pub fn get_database_url() -> Result(String, Nil) {
  env.get_string("DATABASE_URL")
  |> result.replace_error(Nil)
}
