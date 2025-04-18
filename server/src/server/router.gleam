import cors_builder as cors
import gleam/http.{Delete, Get, Options, Post}
import gleam/http/request.{type Request as HttpRequest}
import gleam/http/response.{type Response as HttpResponse}
import mist.{type Connection, type ResponseData}
import server/context.{type Context}
import server/routes/account/login
import server/routes/account/self
import server/routes/account/signup
import server/routes/chat
import server/routes/chat/all
import server/routes/chat/messages
import server/routes/message
import server/routes/user
import wisp.{type Request, type Response}
import wisp/wisp_mist

fn middleware(
  request: Request,
  handle_request: fn(Request) -> Response,
) -> Response {
  use request <- cors.wisp_middleware(request, get_cors())
  let request = wisp.method_override(request)
  use <- wisp.log_request(request)
  use <- wisp.rescue_crashes
  use request <- wisp.handle_head(request)

  handle_request(request)
}

fn get_cors() {
  cors.new()
  |> cors.allow_all_origins()
  |> cors.allow_method(Get)
  |> cors.allow_method(Post)
  |> cors.allow_method(Delete)
  |> cors.allow_method(Options)
  |> cors.allow_header("Content-Type")
  |> cors.allow_header("session_id")
}

pub fn handle_request(
  request: HttpRequest(Connection),
  context: Context,
  secret_key_base: String,
) -> HttpResponse(ResponseData) {
  case request.path_segments(request) {
    _ ->
      wisp_mist.handler(handle_request_wisp(_, context), secret_key_base)(
        request,
      )
  }
}

fn handle_request_wisp(request: Request, context: Context) -> Response {
  use request <- middleware(request)
  case wisp.path_segments(request) {
    ["chat"] -> chat.handle_request(request, context)
    ["message"] -> message.handle_request(request, context)
    ["user"] -> user.handle_request(request, context)
    ["account", "login"] -> login.handle_request(request, context)
    ["account", "self"] -> self.handle_request(request, context)
    ["account", "signup"] -> signup.handle_request(request, context)
    ["chat", "all"] -> all.handle_request(request, context)
    ["chat", "messages"] -> messages.handle_request(request, context)
    _ -> wisp.not_found() |> wisp.string_body("Not found")
  }
}
