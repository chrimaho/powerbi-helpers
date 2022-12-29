let 
  fun_GenericCleanTable = (
    tbl_Table as table
  ) as table =>
    let
      Source = tbl_Table,
      add_Headers = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
      fix_Headers = fun_CleanTableHeaders(add_Headers),
      fix_Types = fun_ConvertListOfColumnsToType(fix_Headers, null, type text)
    in
      fix_Types
in fun_GenericCleanTable