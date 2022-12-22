let
    fun_AddKeys =
        (Table as table, optional PrimaryKeys as nullable list, optional SecondaryKeys as nullable list, optional MaintainExisting as nullable logical) as table =>
            let
                Default_MaintainExisting =
                    if MaintainExisting is null then
                        true
                    else if Value.Is(MaintainExisting, type logical) then
                        MaintainExisting
                    else
                        true,
                ExistingPrimaries = fun_GetKeys(Table, true),
                ExistingSecondaries = fun_GetKeys(Table, true),
                TotalPrimary =
                    if PrimaryKeys <> null then
                        if Default_MaintainExisting then
                            List.Combine(
                                {
                                    PrimaryKeys,
                                    ExistingPrimaries
                                }
                            )
                        else
                            PrimaryKeys
                    else
                        null,
                TotalSecondary =
                    if SecondaryKeys <> null then
                        if Default_MaintainExisting then
                            List.Combine(
                                {
                                    SecondaryKeys,
                                    ExistingSecondaries
                                }
                            )
                        else
                            SecondaryKeys
                    else
                        null,
                AddPrimaryKeysOnly =
                    if
                        TotalPrimary
                        <> null and TotalSecondary
                        = null
                    then
                        Table.ReplaceKeys(
                            Table,
                            {
                                [
                                    Columns = TotalPrimary,
                                    Primary = true
                                ]
                            }
                        )
                    else
                        Table,
                AddSecondaryKeysOnly =
                    if
                        TotalPrimary
                        = null and TotalSecondary
                        <> null
                    then
                        Table.ReplaceKeys(
                            AddPrimaryKeysOnly,
                            {
                                [
                                    Columns = TotalSecondary,
                                    Primary = false
                                ]
                            }
                        )
                    else
                        AddPrimaryKeysOnly,
                AddPrimaryAndSecondaryKeys =
                    if
                        TotalPrimary
                        <> null and TotalSecondary
                        <> null
                    then
                        Table.ReplaceKeys(
                            AddSecondaryKeysOnly,
                            {
                                [
                                    Columns = TotalPrimary,
                                    Primary = true
                                ],
                                [
                                    Columns = TotalSecondary,
                                    Primary = false
                                ]
                            }
                        )
                    else
                        AddSecondaryKeysOnly,
                RemoveKeys =
                    if
                        TotalPrimary
                        = null and TotalSecondary
                        = null
                    then
                        Table.ReplaceKeys(
                            AddPrimaryAndSecondaryKeys,
                            {
                                [
                                    Columns = {},
                                    Primary = false
                                ]
                            }
                        )
                    else
                        AddPrimaryAndSecondaryKeys
            in
                RemoveKeys
in
    fun_AddKeys