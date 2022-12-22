let
    fun_GetSqlQuery =
        (QueriesTable as table, FilterValue as text) as text =>
            let
                Source = Table.Buffer(QueriesTable),
                Filtered =
                    Table.SelectRows(
                        Source,
                        each ([Data] = FilterValue)
                    ),
                SQL = Filtered{0}[Query]
            in
                SQL
in
    fun_GetSqlQuery