select
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
    )