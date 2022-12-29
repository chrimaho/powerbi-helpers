let 
  fun_GenericImportExcelFile = (
    tbl_Source as table, 
    optional txt_FileFilterValue as nullable text, 
    optional txt_SheetName as nullable text
  ) as table =>
    let
      Source = tbl_Source,
      Filter = Table.SelectRows(Source, each Text.Contains([SourceName], txt_FileFilterValue)),
      Navigation = Filter{0}[Content],
      Import = fun_GenericExtractExcelSheet(Navigation, txt_SheetName)
    in
      Import
in 
  fun_GenericImportExcelFile