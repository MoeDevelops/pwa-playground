import gleam/http
import gleam/json
import gleam/list
import gleam/result
import server/api
import server/context.{type Context}
import server/sql
import server/types.{User}
import wisp.{type Request, type Response}
import youid/uuid

pub fn handle_request(request: Request, context: Context) -> Response {
  case request.method {
    http.Get -> get(request, context)
    _ -> wisp.method_not_allowed([http.Get])
  }
}

fn get(request: Request, context: Context) {
  use user_id <- api.try_request(
    wisp.get_query(request)
      |> list.key_find("id")
      |> result.then(uuid.from_string),
    wisp.unprocessable_entity,
  )

  use db_result <- api.try_request(
    sql.get_user_by_id(context.db, user_id),
    wisp.internal_server_error,
  )

  use user <- api.try_request(
    case db_result.rows {
      [sql.GetUserByIdRow(id, username)] -> Ok(User(id, username))
      _ -> Error(Nil)
    },
    wisp.not_found,
  )

  wisp.ok()
  |> wisp.json_body(
    types.encode_user(user)
    |> json.to_string_tree(),
  )
}
