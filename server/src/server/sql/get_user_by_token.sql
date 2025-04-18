select
    u.id,
    u.username
from
    users u
    inner join tokens t on u.id = t.user_id
where
    t.id = $1