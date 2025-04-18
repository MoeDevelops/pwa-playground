select
    exists (
        select
            1
        from
            chats
        where
            id = $1
    )