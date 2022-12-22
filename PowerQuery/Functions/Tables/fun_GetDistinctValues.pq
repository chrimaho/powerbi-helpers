let
    fun_GetDistinctValues =
        (Table as table, Columns as any, optional Sort as nullable logical) as any =>
            let
                Sort =
                    if Sort is null then
                        true
                    else
                        Sort,
                Columns =
                    if Value.Is(Columns, type text) then
                        {
                            Columns
                        }
                    else if Value.Is(Columns, type list) then
                        Columns
                    else
                        null,
                Num_Cols = List.Count(Columns),
                Source = Table,
                Select = Table.SelectColumns(Source, Columns),
                Distinct = Table.Distinct(Select),
                Order =
                    if Sort then
                        Table.Sort(Distinct, Columns)
                    else
                        Distinct
            in
                Order
in
    fun_GetDistinctValues