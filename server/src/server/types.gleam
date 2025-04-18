import gleam/dynamic/decode
import gleam/json.{type Json}
import gleam/result
import youid/uuid.{type Uuid}

pub fn encode_uuid(uuid: Uuid) -> Json {
  uuid
  |> uuid.to_string()
  |> json.string()
}

pub fn uuid_decoder() {
  decode.new_primitive_decoder("Uuid", fn(dynamic) {
    use str <- result.try(
      decode.run(dynamic, decode.string)
      |> result.replace_error(uuid.nil),
    )
    use uuid <- result.try(
      uuid.from_string(str)
      |> result.replace_error(uuid.nil),
    )
    Ok(uuid)
  })
}

pub type User {
  User(id: Uuid, username: String)
}

pub fn encode_user(user: User) -> Json {
  json.object([
    #("id", encode_uuid(user.id)),
    #("username", json.string(user.username)),
  ])
}

pub type Message {
  Message(id: Uuid, author: Uuid, author_name: String, content: String)
}

pub fn encode_message(message: Message) -> Json {
  json.object([
    #("id", encode_uuid(message.id)),
    #("author", encode_uuid(message.author)),
    #("author_name", json.string(message.author_name)),
    #("content", json.string(message.content)),
  ])
}

pub type Chat {
  Chat(id: Uuid, user1: Uuid, username1: String, user2: Uuid, username2: String)
}

pub fn encode_chat(chat: Chat) -> Json {
  let Chat(id:, user1:, username1:, user2:, username2:) = chat
  json.object([
    #("id", encode_uuid(id)),
    #("user1", encode_uuid(user1)),
    #("username1", json.string(username1)),
    #("user2", encode_uuid(user2)),
    #("username2", json.string(username2)),
  ])
}
