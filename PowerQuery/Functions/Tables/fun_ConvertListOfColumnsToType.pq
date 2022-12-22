let fun_ConvertListOfColumnsToType = (tbl_Table as table, optional lst_SourceColumns as nullable list, optional typ_TargetType as nullable type) as table =>
  let
    Source = tbl_Table,
    Columns = if lst_SourceColumns is null then Table.ColumnNames(Source) else lst_SourceColumns,
    Types = List.Repeat({typ_TargetType}, List.Count(Columns)),
    Zip = List.Zip({Columns, Types}),
    Convert = Table.TransformColumnTypes(Source, Zip)
  in
    Convert
in fun_ConvertListOfColumnsToType