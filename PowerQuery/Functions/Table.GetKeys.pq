let
  fun_GetKeys = (
    Table as table, 
    optional UsePrimary as nullable logical
  ) =>
    let
      Default_UsePrimary =
        if UsePrimary is null 
        then true
        else UsePrimary,
      KeysInFirst =
        if List.Count(Table.Keys(Table)) > 0
        then
          if Table.Keys(Table){0}[Primary] = Default_UsePrimary
          then true
          else false
        else false,
      KeysInSecond =
        if List.Count(Table.Keys(Table)) > 1
        then
          if Table.Keys(Table){1}[Primary] = Default_UsePrimary
          then true
          else false
        else false,
      KeysList =
        if KeysInFirst then Table.Keys(Table){0}[Columns]
        else if KeysInSecond then Table.Keys(Table){1}[Columns]
        else {}
    in
      KeysList
in
  fun_GetKeys
