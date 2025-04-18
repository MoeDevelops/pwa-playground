import gleam/http
import gleam/json
import gleam/list
import server/api
import server/context.{type Context}
import server/sql
import server/types
import wisp.{type Request, type Response}

pub fn handle_request(request: Request, context: Context) -> Response {
  case request.method {
    http.Get -> get(request, context)
    _ -> wisp.method_not_allowed([http.Get])
  }
}

fn get(request: Request, context: Context) {
  use user <- api.require_auth_user(request, context)

  use db_result <- api.try_request(
    sql.get_chats_by_user(context.db, user.id),
    wisp.internal_server_error,
  )

  let chats =
    db_result.rows
    |> list.map(fn(row) {
      types.Chat(row.id, row.user1, row.username1, row.user2, row.username2)
    })

  wisp.ok()
  |> wisp.json_body(
    chats |> json.array(types.encode_chat) |> json.to_string_tree(),
  )
}
