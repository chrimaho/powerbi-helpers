let
  fun_RemoveColumnsThatContain = (
    Table as table, 
    optional TextToFind as nullable text
  ) as table =>
    let
      tbl_Columns = fun_GetTableColumns(Table, "Columns"),
      tbl_FilteredColumns = Table.SelectRows(
        tbl_Columns,
        each not Text.Contains([Columns], TextToFind)
      ),
      lst_Columns = Table.ToList(tbl_FilteredColumns),
      tbl_SelectColumns = Table.SelectColumns(Table, lst_Columns)
    in
      tbl_SelectColumns
in
  fun_RemoveColumnsThatContain