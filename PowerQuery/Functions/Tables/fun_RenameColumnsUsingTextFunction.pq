let
  fun_RenameColumnsUsingTextFunction = 
    ( tbl_Table as table
    , optional lst_Columns as nullable list
    , optional fun_TextFunction as nullable function
    ) as table =>
      let
        fun_Function = if fun_TextFunction is null then Text.Upper else fun_TextFunction,
        lst_ColumnsToChange = if lst_Columns is null then Table.ColumnNames(tbl_Table) else lst_Columns,
        lst_UpdatedColumns = List.Transform(lst_ColumnsToChange, each fun_Function(_)),
        lst_Zipped = List.Zip({lst_ColumnsToChange, lst_UpdatedColumns}),
        tbl_UpdatedColumns = Table.RenameColumns(tbl_Table, lst_Zipped)
      in
        tbl_UpdatedColumns
in
  fun_RenameColumnsUsingTextFunction