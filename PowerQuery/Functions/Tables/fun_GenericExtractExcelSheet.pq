let fun_GenericExtractExcelSheet = (bin_File as binary, optional txt_SheetName as nullable text) as table =>
  let
    Extract = Excel.Workbook(bin_File, null, true),
    Filter = Table.SelectRows(Extract, each ([Kind] = "Sheet")),
    SheetName = if txt_SheetName is null then Filter{0}[Item] else txt_SheetName,
    Sheets = Table.Column(Filter, "Item"),
    CheckSheetName = 
        if List.Contains(Sheets, SheetName)
        then SheetName
        else error Error.Record(
            "SheetNotFoundError", 
            "The specified sheet '" & SheetName & "' is not available in the given workbook.", 
            "Try one of: #(cr)#(lf){'" & Text.Combine(Sheets, "', '") & "'}"
        ),
    Navigate = Filter{[Item = CheckSheetName]}[Data],
    Clean = fun_GenericCleanExcelSheet(Navigate)
  in
    Clean
in fun_GenericExtractExcelSheet