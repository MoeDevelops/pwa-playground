import gleam/http
import gleam/json
import gleam/list
import gleam/result
import server/api
import server/context.{type Context}
import server/sql
import server/types
import wisp.{type Request, type Response}
import youid/uuid

pub fn handle_request(request: Request, context: Context) -> Response {
  case request.method {
    http.Get -> get(request, context)
    _ -> wisp.method_not_allowed([http.Get])
  }
}

fn get(request: Request, context: Context) {
  use chat_id <- api.try_request(
    wisp.get_query(request)
      |> list.key_find("id")
      |> result.then(uuid.from_string),
    wisp.unprocessable_entity,
  )

  use <- api.require_auth(request, context)

  use chat_exists_result <- api.try_request(
    sql.chat_exists(context.db, chat_id),
    wisp.internal_server_error,
  )

  use _ <- api.try_request(
    case chat_exists_result.rows {
      [sql.ChatExistsRow(True)] -> Ok(Nil)
      _ -> Error(Nil)
    },
    wisp.not_found,
  )

  use db_result <- api.try_request(
    sql.get_chat_messages(context.db, chat_id),
    wisp.internal_server_error,
  )

  let messages =
    db_result.rows
    |> list.map(fn(row) {
      types.Message(row.id, row.author, row.username, row.content)
    })

  wisp.ok()
  |> wisp.json_body(
    messages |> json.array(types.encode_message) |> json.to_string_tree(),
  )
}
