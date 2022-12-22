let
    fun_CompareTableColumns =
        (Table1 as table, Table2 as table, optional Name1 as nullable text, optional Name2 as nullable text) =>
            let
                default_Name1 =
                    if Name1 is null then
                        "Columns1"
                    else
                        Name1,
                default_Name2 =
                    if Name2 is null then
                        "Columns2"
                    else
                        Name2,
                Columns1 =
                    fun_GetTableColumns(
                        Table1,
                        default_Name1
                    ),
                Columns2 =
                    fun_GetTableColumns(
                        Table2,
                        default_Name2
                    ),
                Join =
                    Table.NestedJoin(
                        Columns1,
                        {default_Name1},
                        Columns2,
                        {default_Name2},
                        "Column",
                        JoinKind.FullOuter
                    ),
                Expand =
                    Table.ExpandTableColumn(
                        Join,
                        "Column",
                        {default_Name2},
                        {default_Name2}
                    )
            in
                Expand
in
    fun_CompareTableColumns