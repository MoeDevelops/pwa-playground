-- migrate:up
create table users (
    id uuid primary key,
    username text not null
);

create table passwords (
    user_id uuid primary key references users (id),
    password text not null
);

create table tokens (
    id uuid primary key,
    user_id uuid not null references users (id)
);

create table chats (
    id uuid primary key,
    user1 uuid not null references users (id),
    user2 uuid not null references users (id)
);

create table messages (
    id uuid primary key,
    chat uuid not null references chats (id),
    author uuid not null references users (id),
    content text not null
);

-- migrate:down
drop table users,
passwords,
tokens,
chats,
messages;