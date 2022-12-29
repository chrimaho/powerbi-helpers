let
  fun_RenameColumnsUsingTextReplace = (
    tbl_Table as table,
    optional lst_Columns as nullable list,
    optional txt_TextToFind as nullable text,
    optional txt_TextToReplace as nullable text
  ) as table =>
    let
      lst_ColumnsToChange = if lst_Columns is null then Table.ColumnNames(tbl_Table) else lst_Columns,
      lst_UpdatedColumns = List.ReplaceValue(
        lst_ColumnsToChange,
        txt_TextToFind,
        txt_TextToReplace,
        Replacer.ReplaceText
      ),
      lst_Zipped = List.Zip({lst_ColumnsToChange,lst_UpdatedColumns}),
      tbl_UpdatedColumns = Table.RenameColumns(tbl_Table, lst_Zipped)
    in
      tbl_UpdatedColumns
in
  fun_RenameColumnsUsingTextReplace
