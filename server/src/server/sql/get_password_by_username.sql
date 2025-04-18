select
    u.id,
    p.password
from
    users u
    inner join passwords p on u.id = p.user_id
where
    u.username = $1