let fun_ConvertTableToText = (tbl_Table as table) as text =>
    let
        Source = tbl_Table,
        get_ColumnsBinary = Table.ColumnsOfType(Source, {type binary}),
        get_ColumnsTable = Table.ColumnsOfType(Source, {type table}),
        get_ColumnsRecord = Table.ColumnsOfType(Source, {type record}),
        get_ColumnsList = Table.ColumnsOfType(Source, {type list}),
        get_ColumnsFunction = Table.ColumnsOfType(Source, {type function}),
        fix_TypesBinary = Table.TransformColumns
            ( Source
            , List.Zip
                (
                    { get_ColumnsBinary
                    , List.Repeat({each "[Binary]"}, List.Count(get_ColumnsBinary))
                    , List.Repeat({type text}, List.Count(get_ColumnsBinary))
                    }
                )
            ),
        fix_TypesTable = Table.TransformColumns
            ( fix_TypesBinary
            , List.Zip
                (
                    { get_ColumnsTable
                    , List.Repeat({each "[Table]"}, List.Count(get_ColumnsTable))
                    , List.Repeat({type text}, List.Count(get_ColumnsTable))
                    }
                )
            ),
        fix_TypesRecord = Table.TransformColumns
            ( fix_TypesTable
            , List.Zip
                (
                    { get_ColumnsRecord
                    , List.Repeat({each "[Record]"}, List.Count(get_ColumnsRecord))
                    , List.Repeat({type text}, List.Count(get_ColumnsRecord))
                    }
                )
            ),
        fix_TypesList = Table.TransformColumns
            ( fix_TypesRecord
            , List.Zip
                (
                    { get_ColumnsList
                    , List.Repeat({each "[Record]"}, List.Count(get_ColumnsList))
                    , List.Repeat({type text}, List.Count(get_ColumnsList))
                    }
                )
            ),
        fix_TypesFunction = Table.TransformColumns
            ( fix_TypesList
            , List.Zip
                (
                    { get_ColumnsFunction
                    , List.Repeat({each "[Function]"}, List.Count(get_ColumnsFunction))
                    , List.Repeat({type text}, List.Count(get_ColumnsFunction))
                    }
                )
            ),
        fix_TypesText = fun_ConvertListOfColumnsToType(fix_TypesFunction, null, type text),
        fix_Headers = Table.DemoteHeaders(fix_TypesText),
        Convert = Text.RemoveRange(
            List.Accumulate(
                Table.ToList(fix_Headers), 
                "", 
                (a,b) => a & "#(cr)#(lf)| " & Text.Replace(b, ",", " | ") & " |"
            ), 
            0, 
            1
        )
    in
        Convert
in fun_ConvertTableToText