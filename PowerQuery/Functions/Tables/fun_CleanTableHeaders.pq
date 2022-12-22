let fun_CleanTableHeaders = (Table as table) as table =>
  let
    fix_Space = fun_RenameColumnsUsingTextReplace(Table, " ", ""),
    fix_Hash = fun_RenameColumnsUsingTextReplace(fix_Space, "#", "No"),
    fix_Apostrophe = fun_RenameColumnsUsingTextReplace(fix_Hash, "'", ""),
    fix_Spelling = fun_RenameColumnsUsingTextReplace(fix_Apostrophe, "Recr", "Receiver"),
    fix_Period = fun_RenameColumnsUsingTextReplace(fix_Spelling, ".", ""),
    fix_LeftParenthesis = fun_RenameColumnsUsingTextReplace(fix_Period, "(", ""),
    fix_RightParenthesis = fun_RenameColumnsUsingTextReplace(fix_LeftParenthesis, ")", ""),
    fix_Underscore = fun_RenameColumnsUsingTextReplace(fix_RightParenthesis, "_", ""),
    fix_Ampersand = fun_RenameColumnsUsingTextReplace(fix_Underscore, "&", "And")
  in
    fix_Ampersand
in fun_CleanTableHeaders