import gleam/http/request
import gleam/result
import server/context.{type Context}
import server/sql
import server/types.{type User, User}
import wisp.{type Response}
import youid/uuid

pub fn try_request(
  result: Result(a, b),
  on_error: fn() -> c,
  function: fn(a) -> c,
) -> c {
  case result {
    Ok(ok) -> function(ok)
    Error(_) -> on_error()
  }
}

pub fn unauthorized() {
  wisp.response(401)
}

pub fn require_auth(
  request,
  context: Context,
  function: fn() -> Response,
) -> Response {
  use token <- try_request(
    request.get_header(request, "session_id")
      |> result.then(uuid.from_string),
    unauthorized,
  )

  use db_result <- try_request(
    sql.token_exists(context.db, token),
    wisp.internal_server_error,
  )

  case db_result.rows {
    [sql.TokenExistsRow(True)] -> function()
    _ -> unauthorized()
  }
}

pub fn require_auth_user(
  request,
  context: Context,
  function: fn(User) -> Response,
) -> Response {
  use token <- try_request(
    request.get_header(request, "session_id")
      |> result.then(uuid.from_string),
    unauthorized,
  )

  use db_result <- try_request(
    sql.get_user_by_token(context.db, token),
    wisp.internal_server_error,
  )

  case db_result.rows {
    [sql.GetUserByTokenRow(id, username)] -> function(User(id, username))
    _ -> unauthorized()
  }
}
