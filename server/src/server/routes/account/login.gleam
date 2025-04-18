import argus
import gleam/bool
import gleam/dynamic/decode.{type Decoder}
import gleam/http
import server/api
import server/context.{type Context}
import server/sql
import server/types
import wisp.{type Request, type Response}
import youid/uuid

pub fn handle_request(request: Request, context: Context) -> Response {
  case request.method {
    http.Post -> post(request, context)
    _ -> wisp.method_not_allowed([http.Post])
  }
}

type LoginRequest {
  LoginRequest(username: String, password: String)
}

fn login_request_decoder() -> Decoder(LoginRequest) {
  use username <- decode.field("username", decode.string)
  use password <- decode.field("password", decode.string)
  decode.success(LoginRequest(username:, password:))
}

fn post(request: Request, context: Context) {
  use json <- wisp.require_json(request)

  use login_request <- api.try_request(
    json |> decode.run(login_request_decoder()),
    wisp.unprocessable_entity,
  )

  use db_result <- api.try_request(
    sql.get_password_by_username(context.db, login_request.username),
    wisp.internal_server_error,
  )

  use #(user, hash) <- api.try_request(
    case db_result.rows {
      [sql.GetPasswordByUsernameRow(id, password)] ->
        Ok(#(types.User(id, login_request.username), password))
      _ -> Error(Nil)
    },
    api.unauthorized,
  )

  use result <- api.try_request(
    argus.verify(hash, login_request.password),
    wisp.internal_server_error,
  )

  use <- bool.lazy_guard(!result, api.unauthorized)

  let token = uuid.v7()

  use _ <- api.try_request(
    sql.new_token(context.db, token, user.id),
    wisp.internal_server_error,
  )

  wisp.ok()
  |> wisp.string_body(token |> uuid.to_string)
}
