let
  fun_ApplyFunctionToMultipleColumns = (
    Table as table, 
    Columns as list, 
    Function as function, 
    Type as nullable type
  ) as table =>
    let
      Result = List.Accumulate(
        Columns,
        Table,
        (state, current) =>
          Table.TransformColumns(
            state,
            {
              {
                current,
                Function,
                Type
              }
            }
          )
      )
    in
      Result
in
  fun_ApplyFunctionToMultipleColumns