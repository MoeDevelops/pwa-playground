select
    exists (
        select
            1
        from
            users
        where
            username = $1
    )