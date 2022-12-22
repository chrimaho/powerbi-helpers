let fun_GenericExtractCsvFile = (bin_File as binary) as table =>
  let
    Extract = Csv.Document(bin_File, [Delimiter = ",", QuoteStyle = QuoteStyle.None]),
    Clean = fun_GenericCleanTable(Extract)
  in
    Clean
in fun_GenericExtractCsvFile