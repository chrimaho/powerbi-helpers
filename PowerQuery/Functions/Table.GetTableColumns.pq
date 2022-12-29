let
  fun_GetTableColumns = (
    Table as table,
    optional Name as nullable text
  ) as table =>
    let
      lst_Columns = Table.ColumnNames(Table),
      tbl_Columns = Table.FromList(
        lst_Columns,
        Splitter.SplitByNothing(),
        if Name is null then null else {Name},
        null,
        ExtraValues.Error
      )
    in
      tbl_Columns
in
  fun_GetTableColumns
