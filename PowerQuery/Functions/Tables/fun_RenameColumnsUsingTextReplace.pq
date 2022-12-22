let
    fun_RenameColumnsUsingTextReplace =
        (Table as table, optional TextToFind as nullable text, optional TextToReplace as nullable text) =>
            let
                lst_Columns = Table.ColumnNames(Table),
                lst_UpdatedColumns =
                    List.ReplaceValue(
                        lst_Columns,
                        TextToFind,
                        TextToReplace,
                        Replacer.ReplaceText
                    ),
                lst_Zipped =
                    List.Zip(
                        {
                            lst_Columns,
                            lst_UpdatedColumns
                        }
                    ),
                tbl_UpdatedColumns = Table.RenameColumns(Table, lst_Zipped)
            in
                tbl_UpdatedColumns
in
    fun_RenameColumnsUsingTextReplace