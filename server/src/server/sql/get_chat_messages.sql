select
    m.id,
    u.id as author,
    u.username,
    m.content
from
    chats c
    inner join messages m on c.id = m.chat
    inner join users u on m.author = u.id
where
    c.id = $1