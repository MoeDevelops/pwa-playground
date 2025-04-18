select
    exists (
        select
            1
        from
            tokens
        where
            id = $1
    )