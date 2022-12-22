let
    fun_GetTableDimensions =
        (Table as table) as table =>
            let
                rows = Table.RowCount(Table),
                cols = Table.ColumnCount(Table),
                dims =
                    Table.FromRecords(
                        {
                            [
                                Rows = rows,
                                Cols = cols
                            ]
                        }
                    )
            in
                dims
in
    fun_GetTableDimensions