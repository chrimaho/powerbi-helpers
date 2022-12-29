let 
  fun_TextContainsAnyOf = (
    txt_Value as text, 
    lst_ValuesToCheck as list
  ) as logical =>
    // Credit to: https://community.powerbi.com/t5/Desktop/How-to-do-the-text-containsany-in-power-query/m-p/932611
    let
      Check = List.AnyTrue(
        List.Transform(
          lst_ValuesToCheck,
          (lst_Item) => Text.Contains(
            txt_Value,
            lst_Item,
            Comparer.OrdinalIgnoreCase
          )
        )
      )
    in
      Check
in 
  fun_TextContainsAnyOf
