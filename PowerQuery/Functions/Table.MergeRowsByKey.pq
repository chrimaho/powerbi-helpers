let 
  fun_MergeRowsByKey = (
    tbl_Table as table, 
    txt_KeyColumn as text, 
    txt_CombineColumn as text
  ) =>
    let
      Source = tbl_Table,
      txt_FixedColumn = Text.Combine({"fix_", txt_CombineColumn}),
      Select = Table.SelectColumns(Source, {txt_KeyColumn, txt_CombineColumn}),
      Aggregate = Table.Group(Select, {txt_KeyColumn}, {{txt_CombineColumn, each Text.Combine(Record.Field(_, txt_CombineColumn), ", "), type text}}),
      fix_DoubleSpaces = Table.TransformColumns(Aggregate, {{txt_CombineColumn, each Text.Replace(_, "  ", " "), type nullable text}}),
      fix_DoubleCommas = Table.TransformColumns(fix_DoubleSpaces, {{txt_CombineColumn, each Text.Replace(_, ", ,", ","), type nullable text}}),
      Merge = Table.NestedJoin(Source, {txt_KeyColumn}, fix_DoubleCommas, {txt_KeyColumn}, txt_FixedColumn, JoinKind.LeftOuter),
      Expand = Table.ExpandTableColumn(Merge, txt_FixedColumn, {txt_CombineColumn}, {txt_FixedColumn}),
      Replace = Table.ReplaceValue(Expand, each Record.Field(_, txt_CombineColumn), each Record.Field(_, txt_FixedColumn), Replacer.ReplaceValue, {txt_CombineColumn}),
      fix_Types = Table.TransformColumnTypes(Replace, {{txt_CombineColumn, type text}}),
      del_FixedColumns = Table.RemoveColumns(fix_Types, {txt_FixedColumn})
    in
      del_FixedColumns
in
  fun_MergeRowsByKey