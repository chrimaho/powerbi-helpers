/*
All credit to:
  - https://www.dingbatdata.com/2020/01/03/editing-static-tables/
  - https://github.com/camwally/Power-Query/blob/master/CreateTable2
*/

let
  fun_ConvertTableToCode = (
    tbl_InputTable as table
  ) as text =>
    let
      source = Table.Schema(tbl_InputTable),
      sortRows = Table.Sort(
        source,
        {
          {
            "Position",
            Order.Ascending
          }
        }
      ),
      simplifyTypeNameRec = [
        #"Any.Type" = "any",
        #"Binary.Type" = "binary",
        #"Date.Type" = "date",
        #"DateTime.Type" = "datetime",
        #"DateTimeZone.Type" = "datetimezone",
        #"Duration.Type" = "duration",
        #"Function.Type" = "function",
        #"List.Type" = "list",
        #"Logical.Type" = "logical",
        #"None.Type" = "none",
        #"Null.Type" = "null",
        #"Number.Type" = "number",
        #"Record.Type" = "record",
        #"Table.Type" = "table",
        #"Text.Type" = "text",
        #"Time.Type" = "time",
        #"Type.Type" = "type"
      ],
      simplifyTypeNames = Table.TransformColumns(
        sortRows,
        {
          {
            "TypeName",
            each
              Record.FieldOrDefault(
                simplifyTypeNameRec,
                _,
                _
              )
          }
        }
      ),
      selectColumns = Table.SelectColumns(
        simplifyTypeNames,
        {
          "Name",
          "TypeName",
          "IsNullable"
        }
      ),
      addColOfTypeNames = Table.AddColumn(
        selectColumns,
        "TypeNames",
        each
          Expression.Identifier([Name])
          & " = "
          & (
            if [IsNullable] then
              "nullable "
            else
              ""
          )
          & [TypeName]
      ),
      tableTypeRec =
        "["
        & Text.Combine(
          addColOfTypeNames[TypeNames],
          ", "
        )
        & "]"//Code above is based on a function by Chris Webb
      ,
      tableOfExpressions =
        Table.TransformColumns(
          tbl_InputTable,
          {},
          Expression.Constant
        ),
      listOfCols = Table.ToColumns(tableOfExpressions),
      listOfColsOfPaddedText =
        List.Transform(
          listOfCols,
          (col as list) =>
            let
              buf = List.Buffer(col),
              maxTextLength = List.Max(List.Transform(buf, Text.Length)),
              paddedText =
                List.Transform(
                  buf,
                  each Text.PadEnd(_, maxTextLength)
                )
            in
              paddedText
        ),
      listOfRowsOfPaddedText = List.Zip(listOfColsOfPaddedText),
      bodyAsList =
        List.Transform(
          listOfRowsOfPaddedText,
          (row as list) => "{" & Text.Combine(row, ",") & "}"
        ),
      bodyAsText =
        "{"
        & Text.Combine(bodyAsList, "#(lf),")
        & "#(lf)}",
      together =
        "#table(type table "
        & tableTypeRec
        & ",#(lf)"
        & bodyAsText
        & ")"
    in
      together
in
  fun_ConvertTableToCode
