import gleam/http
import gleam/json
import server/api
import server/context.{type Context}
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

  wisp.ok()
  |> wisp.json_body(
    user
    |> types.encode_user()
    |> json.to_string_tree(),
  )
}
