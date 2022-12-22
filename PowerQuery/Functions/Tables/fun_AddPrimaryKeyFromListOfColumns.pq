let
    fun_AddPrimaryKeyFromListOfColumns =
        (Table as table, Columns as list, optional KeyName as nullable text) as table =>
            let
                default_KeyName =
                    if KeyName is null then
                        "KeyColumn"
                    else
                        KeyName,
                tbl_AddIndex =
                    Table.AddIndexColumn(
                        Table,
                        "Index",
                        1,
                        1,
                        Int64.Type
                    ),
                tbl_KeyColumns = Table.SelectColumns(Table, Columns),
                lst_KeyColumns =
                    Table.ToList(
                        tbl_KeyColumns,
                        Combiner.CombineTextByDelimiter("_")
                    ),
                tbl_AppliedKeyColumns =
                    Table.AddColumn(
                        tbl_AddIndex,
                        default_KeyName,
                        each lst_KeyColumns{[Index]},
                        type text
                    ),
                tbl_AddKeys =
                    fun_AddKeys(
                        tbl_AppliedKeyColumns,
                        {default_KeyName},
                        null,
                        false
                    ),
                tbl_RemoveIndex =
                    Table.RemoveColumns(
                        tbl_AddKeys,
                        {"Index"}
                    )
            in
                tbl_RemoveIndex,
    doc_AddPrimaryKeyFromListOfColumns =
        type function (Table as
            (
                type table
                meta
                [
                    Documentation.FieldCaption = "Table",
                    Documentation.FieldDescription = "The table to update."
                ]
            ), Columns as
            (
                type list
                meta
                [
                    Documentation.FieldCaption = "Columns",
                    Documentation.FieldDescription = "The columns to combine for the updated key."
                ]
            ), optional KeyName as
            (
                type text
                meta
                [
                    Documentation.FieldCaption = "KeyName",
                    Documentation.FieldDescription = "The column name for the new key field.",
                    Documentation.SampleValues = {
                        "key_Column",
                        "key_Column1_Column2"
                    }
                ]
            )) as table
        meta
        [
            Documentation.Name = "fun_AddPrimaryKeyFromListOfColumns",
            Documentation.LongDescription = "Add a Primary Key column to a table from concatenation of a number of other columns.",
            Documentation.Examples = {
                [
                    Description = "Basic usage",
                    Code =
                        "let
    Table = 
        #table(
            { ""Col1"", ""Col2"", ""Col3""},
            { {1, ""A"", ""B""}
            , {2, ""C"", ""D""}
            }
        ),
in
    fun_AddPrimaryKeyFromListOfColumns(Table, {""Col2"",""Col3""}, ""key_Col2_Col3"")
",
                    Result =
                        "#table(
    { ""Col1"", ""Col2"", ""Col3"", ""key_Col2_Col3""},
    { {1, ""A"", ""B"", ""A_B""}
    , {2, ""C"", ""D"", ""A_B""}
    }
)
"
                ]
            }
        ],
    met_AddPrimaryKeyFromListOfColumns =
        Value.ReplaceType(
            fun_AddPrimaryKeyFromListOfColumns,
            doc_AddPrimaryKeyFromListOfColumns
        )
in
    met_AddPrimaryKeyFromListOfColumns