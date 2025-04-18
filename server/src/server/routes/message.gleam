import gleam/bool
import gleam/dynamic/decode.{type Decoder}
import gleam/http
import gleam/json
import gleam/string
import server/api
import server/context.{type Context}
import server/sql
import server/types.{Message}
import wisp.{type Request, type Response}
import youid/uuid.{type Uuid}

pub fn handle_request(request: Request, context: Context) -> Response {
  case request.method {
    http.Post -> post(request, context)
    _ -> wisp.method_not_allowed([http.Post])
  }
}

type NewMessage {
  NewMessage(chat: Uuid, message: String)
}

fn new_message_decoder() -> Decoder(NewMessage) {
  use chat <- decode.field("chat", types.uuid_decoder())
  use message <- decode.field("message", decode.string)
  decode.success(NewMessage(chat:, message:))
}

fn post(request: Request, context: Context) {
  use json <- wisp.require_json(request)

  use new_message <- api.try_request(
    json |> decode.run(new_message_decoder()),
    wisp.unprocessable_entity,
  )

  let message_length = new_message.message |> string.length()

  use <- bool.lazy_guard(
    message_length <= 0 || message_length > 4000,
    wisp.unprocessable_entity,
  )

  use user <- api.require_auth_user(request, context)

  use user_is_part_of_chat_result <- api.try_request(
    sql.user_is_part_of_chat(context.db, new_message.chat, user.id),
    wisp.internal_server_error,
  )

  use <- bool.lazy_guard(
    user_is_part_of_chat_result.rows != [sql.UserIsPartOfChatRow(True)],
    api.unauthorized,
  )

  let message = Message(uuid.v7(), user.id, user.username, new_message.message)

  use _ <- api.try_request(
    sql.new_message(
      context.db,
      message.id,
      new_message.chat,
      message.author,
      message.content,
    ),
    wisp.internal_server_error,
  )

  wisp.created()
  |> wisp.json_body(
    types.encode_message(message)
    |> json.to_string_tree(),
  )
}
