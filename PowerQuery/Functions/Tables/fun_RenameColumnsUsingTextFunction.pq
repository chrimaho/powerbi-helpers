let fun_RenameColumnsUsingTextFunction = (tbl_Table as table, optional fun_TextFunction as nullable function) =>
    let
        fun_Function = if fun_TextFunction is null then Text.Upper else fun_TextFunction,
        lst_Columns = Table.ColumnNames(tbl_Table),
        lst_UpdatedColumns = List.Transform(lst_Columns, each fun_Function(_)),
        lst_Zipped = List.Zip({lst_Columns, lst_UpdatedColumns}),
        tbl_UpdatedColumns = Table.RenameColumns(tbl_Table, lst_Zipped)
    in
        tbl_UpdatedColumns
in
    fun_RenameColumnsUsingTextFunction