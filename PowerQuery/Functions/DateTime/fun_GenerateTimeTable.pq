let
    Source =
        () as table =>
            let
                Source =
                    List.Times(
                        #time(0, 0, 0),
                        60 * 24,
                        #duration(0, 0, 1, 0)
                    ),
                ToTable =
                    Table.FromList(
                        Source,
                        Splitter.SplitByNothing(),
                        {"Time"},
                        null,
                        ExtraValues.Error
                    ),
                ChangedTypes =
                    Table.TransformColumnTypes(
                        ToTable,
                        {
                            {
                                "Time",
                                type time
                            }
                        }
                    ),
                add_Format =
                    Table.AddColumn(
                        ChangedTypes,
                        "Format",
                        each
                            Time.ToText(
                                [Time],
                                [
                                    Format = "hh:mm:ss",
                                    Culture = "en-AU"
                                ]
                            ),
                        type text
                    ),
                add_Index =
                    Table.AddIndexColumn(
                        add_Format,
                        "Index",
                        1,
                        1
                    ),
                add_Hour =
                    Table.AddColumn(
                        add_Index,
                        "Hour",
                        each Time.Hour([Time]),
                        Int64.Type
                    ),
                add_Minute =
                    Table.AddColumn(
                        add_Hour,
                        "Minute",
                        each Time.Minute([Time]),
                        Int64.Type
                    ),
                add_AmPm =
                    Table.AddColumn(
                        add_Minute,
                        "TimeOfDay",
                        each
                            if [Hour] < 12 then
                                "AM"
                            else
                                "PM",
                        type text
                    ),
                add_Now =
                    Table.AddColumn(
                        add_AmPm,
                        "Now",
                        each Time.From(dtm_Now),
                        type time
                    ),
                add_IsNow =
                    Table.AddColumn(
                        add_Now,
                        "IsNow",
                        each [Time] = [Now],
                        type logical
                    ),
                add_BeforeNow =
                    Table.AddColumn(
                        add_IsNow,
                        "BeforeNow",
                        each [Time] <= [Now],
                        type logical
                    ),
                add_AfterNow =
                    Table.AddColumn(
                        add_BeforeNow,
                        "AfterNow",
                        each [Time] >= [Now],
                        type logical
                    )
            in
                add_AfterNow
in
    Source