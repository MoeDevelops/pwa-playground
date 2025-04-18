import gleam/dynamic/decode
import pog
import youid/uuid.{type Uuid}

/// A row you get from running the `get_chats_by_user` query
/// defined in `./src/server/sql/get_chats_by_user.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.2 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type GetChatsByUserRow {
  GetChatsByUserRow(
    id: Uuid,
    user1: Uuid,
    username1: String,
    user2: Uuid,
    username2: String,
  )
}

/// Runs the `get_chats_by_user` query
/// defined in `./src/server/sql/get_chats_by_user.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.2 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn get_chats_by_user(db, arg_1) {
  let decoder = {
    use id <- decode.field(0, uuid_decoder())
    use user1 <- decode.field(1, uuid_decoder())
    use username1 <- decode.field(2, decode.string)
    use user2 <- decode.field(3, uuid_decoder())
    use username2 <- decode.field(4, decode.string)
    decode.success(GetChatsByUserRow(
      id:,
      user1:,
      username1:,
      user2:,
      username2:,
    ))
  }

  "select
    c.id,
    c.user1,
    u1.username as username1,
    c.user2,
    u2.username as username2
from
    chats c
    inner join users u1 on c.user1 = u1.id
    inner join users u2 on c.user2 = u2.id
where
    c.user1 = $1 or
    c.user2 = $1"
  |> pog.query
  |> pog.parameter(pog.text(uuid.to_string(arg_1)))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `chat_exists` query
/// defined in `./src/server/sql/chat_exists.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.2 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type ChatExistsRow {
  ChatExistsRow(exists: Bool)
}

/// Runs the `chat_exists` query
/// defined in `./src/server/sql/chat_exists.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.2 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn chat_exists(db, arg_1) {
  let decoder = {
    use exists <- decode.field(0, decode.bool)
    decode.success(ChatExistsRow(exists:))
  }

  "select
    exists (
        select
            1
        from
            chats
        where
            id = $1
    )"
  |> pog.query
  |> pog.parameter(pog.text(uuid.to_string(arg_1)))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `get_chat_messages` query
/// defined in `./src/server/sql/get_chat_messages.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.2 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type GetChatMessagesRow {
  GetChatMessagesRow(id: Uuid, author: Uuid, username: String, content: String)
}

/// Runs the `get_chat_messages` query
/// defined in `./src/server/sql/get_chat_messages.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.2 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn get_chat_messages(db, arg_1) {
  let decoder = {
    use id <- decode.field(0, uuid_decoder())
    use author <- decode.field(1, uuid_decoder())
    use username <- decode.field(2, decode.string)
    use content <- decode.field(3, decode.string)
    decode.success(GetChatMessagesRow(id:, author:, username:, content:))
  }

  "select
    m.id,
    u.id as author,
    u.username,
    m.content
from
    chats c
    inner join messages m on c.id = m.chat
    inner join users u on m.author = u.id
where
    c.id = $1"
  |> pog.query
  |> pog.parameter(pog.text(uuid.to_string(arg_1)))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `get_password_by_username` query
/// defined in `./src/server/sql/get_password_by_username.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.2 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type GetPasswordByUsernameRow {
  GetPasswordByUsernameRow(id: Uuid, password: String)
}

/// Runs the `get_password_by_username` query
/// defined in `./src/server/sql/get_password_by_username.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.2 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn get_password_by_username(db, arg_1) {
  let decoder = {
    use id <- decode.field(0, uuid_decoder())
    use password <- decode.field(1, decode.string)
    decode.success(GetPasswordByUsernameRow(id:, password:))
  }

  "select
    u.id,
    p.password
from
    users u
    inner join passwords p on u.id = p.user_id
where
    u.username = $1"
  |> pog.query
  |> pog.parameter(pog.text(arg_1))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// Runs the `new_chat` query
/// defined in `./src/server/sql/new_chat.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.2 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn new_chat(db, arg_1, arg_2, arg_3) {
  let decoder = decode.map(decode.dynamic, fn(_) { Nil })

  "insert into
    chats (id, user1, user2)
values
    ($1, $2, $3)"
  |> pog.query
  |> pog.parameter(pog.text(uuid.to_string(arg_1)))
  |> pog.parameter(pog.text(uuid.to_string(arg_2)))
  |> pog.parameter(pog.text(uuid.to_string(arg_3)))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `get_user_by_username` query
/// defined in `./src/server/sql/get_user_by_username.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.2 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type GetUserByUsernameRow {
  GetUserByUsernameRow(id: Uuid, username: String)
}

/// Runs the `get_user_by_username` query
/// defined in `./src/server/sql/get_user_by_username.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.2 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn get_user_by_username(db, arg_1) {
  let decoder = {
    use id <- decode.field(0, uuid_decoder())
    use username <- decode.field(1, decode.string)
    decode.success(GetUserByUsernameRow(id:, username:))
  }

  "select
    id,
    username
from
    users
where
    username = $1"
  |> pog.query
  |> pog.parameter(pog.text(arg_1))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// Runs the `new_token` query
/// defined in `./src/server/sql/new_token.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.2 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn new_token(db, arg_1, arg_2) {
  let decoder = decode.map(decode.dynamic, fn(_) { Nil })

  "insert into
    tokens (id, user_id)
values
    ($1, $2)"
  |> pog.query
  |> pog.parameter(pog.text(uuid.to_string(arg_1)))
  |> pog.parameter(pog.text(uuid.to_string(arg_2)))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// Runs the `new_password` query
/// defined in `./src/server/sql/new_password.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.2 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn new_password(db, arg_1, arg_2) {
  let decoder = decode.map(decode.dynamic, fn(_) { Nil })

  "insert into
    passwords (user_id, password)
values
    ($1, $2)"
  |> pog.query
  |> pog.parameter(pog.text(uuid.to_string(arg_1)))
  |> pog.parameter(pog.text(arg_2))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// Runs the `new_user` query
/// defined in `./src/server/sql/new_user.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.2 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn new_user(db, arg_1, arg_2) {
  let decoder = decode.map(decode.dynamic, fn(_) { Nil })

  "insert into
    users (id, username)
values
    ($1, $2)"
  |> pog.query
  |> pog.parameter(pog.text(uuid.to_string(arg_1)))
  |> pog.parameter(pog.text(arg_2))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `username_exists` query
/// defined in `./src/server/sql/username_exists.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.2 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type UsernameExistsRow {
  UsernameExistsRow(exists: Bool)
}

/// Runs the `username_exists` query
/// defined in `./src/server/sql/username_exists.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.2 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn username_exists(db, arg_1) {
  let decoder = {
    use exists <- decode.field(0, decode.bool)
    decode.success(UsernameExistsRow(exists:))
  }

  "select
    exists (
        select
            1
        from
            users
        where
            username = $1
    )"
  |> pog.query
  |> pog.parameter(pog.text(arg_1))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// Runs the `new_message` query
/// defined in `./src/server/sql/new_message.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.2 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn new_message(db, arg_1, arg_2, arg_3, arg_4) {
  let decoder = decode.map(decode.dynamic, fn(_) { Nil })

  "insert into
    messages (
        id,
        chat,
        author,
        content
    )
values
    ($1, $2, $3, $4)"
  |> pog.query
  |> pog.parameter(pog.text(uuid.to_string(arg_1)))
  |> pog.parameter(pog.text(uuid.to_string(arg_2)))
  |> pog.parameter(pog.text(uuid.to_string(arg_3)))
  |> pog.parameter(pog.text(arg_4))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `user_is_part_of_chat` query
/// defined in `./src/server/sql/user_is_part_of_chat.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.2 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type UserIsPartOfChatRow {
  UserIsPartOfChatRow(exists: Bool)
}

/// Runs the `user_is_part_of_chat` query
/// defined in `./src/server/sql/user_is_part_of_chat.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.2 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn user_is_part_of_chat(db, arg_1, arg_2) {
  let decoder = {
    use exists <- decode.field(0, decode.bool)
    decode.success(UserIsPartOfChatRow(exists:))
  }

  "select
    exists (
        select
            1
        from
            chats c
            inner join users u1 on c.user1 = u1.id
            inner join users u2 on c.user2 = u2.id
        where
            c.id = $1 and
            (
                u1.id = $2 or
                u2.id = $2
            )
    )"
  |> pog.query
  |> pog.parameter(pog.text(uuid.to_string(arg_1)))
  |> pog.parameter(pog.text(uuid.to_string(arg_2)))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `get_user_by_token` query
/// defined in `./src/server/sql/get_user_by_token.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.2 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type GetUserByTokenRow {
  GetUserByTokenRow(id: Uuid, username: String)
}

/// Runs the `get_user_by_token` query
/// defined in `./src/server/sql/get_user_by_token.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.2 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn get_user_by_token(db, arg_1) {
  let decoder = {
    use id <- decode.field(0, uuid_decoder())
    use username <- decode.field(1, decode.string)
    decode.success(GetUserByTokenRow(id:, username:))
  }

  "select
    u.id,
    u.username
from
    users u
    inner join tokens t on u.id = t.user_id
where
    t.id = $1"
  |> pog.query
  |> pog.parameter(pog.text(uuid.to_string(arg_1)))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `token_exists` query
/// defined in `./src/server/sql/token_exists.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.2 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type TokenExistsRow {
  TokenExistsRow(exists: Bool)
}

/// Runs the `token_exists` query
/// defined in `./src/server/sql/token_exists.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.2 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn token_exists(db, arg_1) {
  let decoder = {
    use exists <- decode.field(0, decode.bool)
    decode.success(TokenExistsRow(exists:))
  }

  "select
    exists (
        select
            1
        from
            tokens
        where
            id = $1
    )"
  |> pog.query
  |> pog.parameter(pog.text(uuid.to_string(arg_1)))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `get_user_by_id` query
/// defined in `./src/server/sql/get_user_by_id.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.2 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type GetUserByIdRow {
  GetUserByIdRow(id: Uuid, username: String)
}

/// Runs the `get_user_by_id` query
/// defined in `./src/server/sql/get_user_by_id.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.2 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn get_user_by_id(db, arg_1) {
  let decoder = {
    use id <- decode.field(0, uuid_decoder())
    use username <- decode.field(1, decode.string)
    decode.success(GetUserByIdRow(id:, username:))
  }

  "select
    id,
    username
from
    users
where
    id = $1"
  |> pog.query
  |> pog.parameter(pog.text(uuid.to_string(arg_1)))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

// --- Encoding/decoding utils -------------------------------------------------

/// A decoder to decode `Uuid`s coming from a Postgres query.
///
fn uuid_decoder() {
  use bit_array <- decode.then(decode.bit_array)
  case uuid.from_bit_array(bit_array) {
    Ok(uuid) -> decode.success(uuid)
    Error(_) -> decode.failure(uuid.v7(), "uuid")
  }
}
