select
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
    c.user2 = $1