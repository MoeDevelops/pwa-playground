import argus
import gleam/bool
import gleam/dynamic/decode.{type Decoder}
import gleam/http
import gleam/string
import server/api
import server/context.{type Context}
import server/sql
import wisp.{type Request, type Response}
import youid/uuid

pub fn handle_request(request: Request, context: Context) -> Response {
  case request.method {
    http.Post -> post(request, context)
    _ -> wisp.method_not_allowed([http.Post])
  }
}

type NewAccount {
  NewAccount(username: String, password: String)
}

fn new_account_decoder() -> Decoder(NewAccount) {
  use username <- decode.field("username", decode.string)
  use password <- decode.field("password", decode.string)
  decode.success(NewAccount(username:, password:))
}

fn post(request: Request, context: Context) {
  use json <- wisp.require_json(request)

  use new_account <- api.try_request(
    json |> decode.run(new_account_decoder()),
    wisp.unprocessable_entity,
  )

  let username_length = new_account.username |> string.length()

  use <- bool.lazy_guard(
    username_length < 3 || username_length > 32,
    wisp.unprocessable_entity,
  )

  let user_id = uuid.v7()

  use _ <- api.try_request(
    sql.new_user(context.db, user_id, new_account.username),
    wisp.internal_server_error,
  )

  use hash <- api.try_request(
    argus.hash(argus.hasher(), new_account.password, argus.gen_salt()),
    wisp.unprocessable_entity,
  )

  use _ <- api.try_request(
    sql.new_password(context.db, user_id, hash.encoded_hash),
    wisp.internal_server_error,
  )

  let token = uuid.v7()

  use _ <- api.try_request(
    sql.new_token(context.db, token, user_id),
    wisp.internal_server_error,
  )

  wisp.created()
  |> wisp.string_body(token |> uuid.to_string)
}
