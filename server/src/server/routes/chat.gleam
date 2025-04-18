import gleam/dynamic/decode.{type Decoder}
import gleam/http
import gleam/json
import server/api
import server/context.{type Context}
import server/sql
import server/types.{Chat, User}
import wisp.{type Request, type Response}
import youid/uuid

pub fn handle_request(request: Request, context: Context) -> Response {
  case request.method {
    http.Post -> post(request, context)
    _ -> wisp.method_not_allowed([http.Post])
  }
}

type NewChat {
  NewChat(username: String)
}

fn new_chat_decoder() -> Decoder(NewChat) {
  use username <- decode.field("username", decode.string)
  decode.success(NewChat(username:))
}

fn post(request: Request, context: Context) {
  use json <- wisp.require_json(request)

  use new_chat <- api.try_request(
    decode.run(json, new_chat_decoder()),
    wisp.unprocessable_entity,
  )

  use user1 <- api.require_auth_user(request, context)

  use user2_result <- api.try_request(
    sql.get_user_by_username(context.db, new_chat.username),
    wisp.internal_server_error,
  )

  use user2 <- api.try_request(
    case user2_result.rows {
      [sql.GetUserByUsernameRow(id, username)] -> Ok(User(id, username))
      _ -> Error(Nil)
    },
    wisp.not_found,
  )

  let id = uuid.v7()

  use _ <- api.try_request(
    sql.new_chat(context.db, id, user1.id, user2.id),
    wisp.internal_server_error,
  )

  let chat = Chat(id, user1.id, user1.username, user2.id, user2.username)

  wisp.created()
  |> wisp.json_body(
    chat
    |> types.encode_chat()
    |> json.to_string_tree(),
  )
}
