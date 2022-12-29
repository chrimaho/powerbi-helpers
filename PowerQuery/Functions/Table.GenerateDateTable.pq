let
  Table.GenerateDateTable = (
    StartDate as date, 
    EndDate as date, 
    optional Culture as nullable text
  ) as table =>
    let
      DayCount = Duration.Days(Duration.From(EndDate - StartDate)),
      Source =
        List.Dates(
          StartDate,
          DayCount,
          #duration(1, 0, 0, 0)
        ),
      TableFromList =
        Table.FromList(
          Source,
          Splitter.SplitByNothing()
        ),
      Type =
        Table.TransformColumnTypes(
          TableFromList,
          {
            {
              "Column1",
              type date
            }
          }
        ),
      Rename =
        Table.RenameColumns(
          Type,
          {
            {
              "Column1",
              "Date"
            }
          }
        ),
      add_Format =
        Table.AddColumn(
          Rename,
          "Format",
          each
            Date.ToText(
              [Date],
              "ddd dd/MMM/yy",
              Culture
            ),
          type text
        ),
      add_FormatShort =
        Table.AddColumn(
          add_Format,
          "FormatShort",
          each
            Date.ToText(
              [Date],
              "ddd dd/MMM",
              Culture
            ),
          type text
        ),
      add_FormatVeryShort =
        Table.AddColumn(
          add_FormatShort,
          "FormatVeryShort",
          each Date.ToText([Date], "dd/MMM", Culture),
          type text
        ),
      add_Index =
        Table.AddIndexColumn(
          add_FormatVeryShort,
          "Index",
          1,
          1,
          Int64.Type
        ),
      add_Year =
        Table.AddColumn(
          add_Index,
          "Year",
          each Date.Year([Date]),
          Int64.Type
        ),
      add_YearName = 
        Table.AddColumn(
          add_Year,
          "YearName",
          each Number.ToText([Year]),
          type text
        ),
      add_Half =
        Table.AddColumn(
          add_YearName,
          "HalfNum",
          each
            if List.Contains({1,2}, Date.QuarterOfYear([Date])) then 1
            else if List.Contains({3,4}, Date.QuarterOfYear([Date])) then 2
            else null,
          Int64.Type
        ),
      add_HalfName =
        Table.AddColumn(
          add_Half,
          "HalfName",
          each "Half" & Text.PadStart(Number.ToText([HalfNum]), 2, "0"),
          type text
        ),
      add_HalfNameShort =
        Table.AddColumn(
          add_HalfName,
          "HalfNameShort",
          each "H" & Text.PadStart(Number.ToText([HalfNum]), 2, "0"),
          type text
        ),
      add_HalfYear = 
        Table.AddColumn(
          add_HalfNameShort,
          "HalfYear",
          each Text.Combine({[YearName],[HalfNameShort]}, " "),
          type text
        ),
      add_Quarter =
        Table.AddColumn(
          add_HalfYear,
          "QuarterNum",
          each Date.QuarterOfYear([Date]),
          Int64.Type
        ),
      add_QuarterName =
        Table.AddColumn(
          add_Quarter,
          "QuarterName",
          each "Quarter" & Text.PadStart(Number.ToText([QuarterNum]), 2, "0"),
          type text
        ),
      add_QuarterNameShort =
        Table.AddColumn(
          add_QuarterName,
          "QuarterNameShort",
          each "Q" & Text.PadStart(Number.ToText([QuarterNum]), 2, "0"),
          type text
        ),
      add_CalendarQtr =
        Table.AddColumn(
          add_QuarterNameShort,
          "QuarterYear",
          each Text.Combine({[YearName],[QuarterNameShort]}, " "),
          type text
        ),
      add_CalendarQtrOrder =
        Table.AddColumn(
          add_CalendarQtr,
          "QuarterYearOrder",
          each [Year] * 100 + [QuarterNum],
          Int64.Type
        ),
      add_Month =
        Table.AddColumn(
          add_CalendarQtrOrder,
          "MonthNum",
          each Date.Month([Date]),
          Int64.Type
        ),
      add_MonthName =
        Table.AddColumn(
          add_Month,
          "MonthName",
          each Date.ToText([Date], "MMMM", Culture),
          type text
        ),
      add_MonthNameShort =
        Table.AddColumn(
          add_MonthName,
          "MonthNameShort",
          each Date.ToText([Date], "MMM", Culture),
          type text
        ),
      add_MonthNameNumber = 
        Table.AddColumn(
          add_MonthNameShort,
          "MonthNameNumber",
          each "Month" & Text.PadStart(Number.ToText([MonthNum]), 2, "0"),
          type text
        ),
      add_MonthNameNumberShort = 
        Table.AddColumn(
          add_MonthNameNumber,
          "MonthNameNumberShort",
          each "M" & Text.PadStart(Number.ToText([MonthNum]), 2, "0"),
          type text
        ),
      add_CalendarMonth =
        Table.AddColumn(
          add_MonthNameNumberShort,
          "MonthYear",
          each
            (try (Text.Range([MonthName], 0, 3)) otherwise [MonthName])
            & " "
            & Number.ToText([Year]),
          type text
        ),
      add_CalendarMonthOrder =
        Table.AddColumn(
          add_CalendarMonth,
          "MonthYearOrder",
          each [Year] * 100 + [MonthNum],
          Int64.Type
        ),
      add_Week =
        Table.AddColumn(
          add_CalendarMonthOrder,
          "WeekNum",
          each Date.WeekOfYear([Date]),
          Int64.Type
        ),
      add_WeekName =
        Table.AddColumn(
          add_Week,
          "WeekName",
          each
            "Week"
            & Text.PadStart(
              Number.ToText([WeekNum]),
              2,
              "0"
            ),
          type text
        ),
      add_CalendarWk =
        Table.AddColumn(
          add_WeekName,
          "WeekYear",
          each [WeekName] & " " & Number.ToText([Year]),
          type text
        ),
      add_CalendarWkOrder =
        Table.AddColumn(
          add_CalendarWk,
          "WeekYearOrder",
          each [Year] * 100 + [WeekNum],
          Int64.Type
        ),
      add_WeekEnding =
        Table.AddColumn(
          add_CalendarWkOrder,
          "WeekEnding",
          each Date.EndOfWeek([Date]),
          type date
        ),
      add_Day =
        Table.AddColumn(
          add_WeekEnding,
          "MonthDayNum",
          each Date.Day([Date]),
          Int64.Type
        ),
      add_DayInt =
        Table.AddColumn(
          add_Day,
          "DateInt",
          each
            [Year]
            * 10000
            + [MonthNum]
            * 100
            + [MonthDayNum],
          Int64.Type
        ),
      add_DayWeek =
        Table.AddColumn(
          add_DayInt,
          "DayNumWeek",
          each Date.DayOfWeek([Date]) + 1,
          Int64.Type
        ),
      add_DayName =
        Table.AddColumn(
          add_DayWeek,
          "DayName",
          each Date.ToText([Date], "dddd", Culture),
          type text
        ),
      add_Weekend =
        Table.AddColumn(
          add_DayName,
          "Weekend",
          each
            if
              List.Contains(
                {
                  6,
                  7
                },
                [DayNumWeek]
              )
            then
              true
            else
              false,
          type logical
        ),
      add_DayNameShort =
        Table.AddColumn(
          add_Weekend,
          "DayNameShort",
          each Date.ToText([Date], "ddd", Culture),
          type text
        ),
      add_DayOfYear =
        Table.AddColumn(
          add_DayNameShort,
          "DayOfYear",
          each Date.DayOfYear([Date]),
          Int64.Type
        ),
      add_CurrentDay =
        Table.AddColumn(
          add_DayOfYear,
          "CurrentDay",
          each [Date] = Date.From(dtm_Now),
          type logical
        ),
      add_PreviousWorkingDay =
        Table.AddColumn(
          add_CurrentDay,
          "PreviousWorkingDay",
          each
            [Date]
            = fun_PreviousWorkingDay(Date.From(dtm_Now)),
          type logical
        ),
      add_NextWorkingDay =
        Table.AddColumn(
          add_PreviousWorkingDay,
          "NextWorkingDay",
          each
            [Date]
            = fun_NextWorkingDay(Date.From(dtm_Now)),
          type logical
        ),
      add_CurrentWeek =
        Table.AddColumn(
          add_NextWorkingDay,
          "CurrentWeek",
          each Date.IsInCurrentWeek([Date]),
          type logical
        ),
      add_CurrentMonth =
        Table.AddColumn(
          add_CurrentWeek,
          "CurrentMonth",
          each Date.IsInCurrentMonth([Date]),
          type logical
        ),
      add_CurrentQuarter =
        Table.AddColumn(
          add_CurrentMonth,
          "CurrentQuarter",
          each Date.IsInCurrentQuarter([Date]),
          type logical
        ),
      add_CurrentYear =
        Table.AddColumn(
          add_CurrentQuarter,
          "CurrentYear",
          each Date.IsInCurrentYear([Date]),
          type logical
        ),
      add_InRecentWeek =
        Table.AddColumn(
          add_CurrentYear,
          "InRecentWeek",
          each
            [Date]
            >= Date.StartOfWeek(Date.AddWeeks(Date.From(dtm_Now), -1)) and [Date]
            <= Date.From(dtm_Now),
          type logical
        ),
      add_InRecentFortnight =
        Table.AddColumn(
          add_InRecentWeek,
          "InRecentFortnight",
          each
            [Date]
            >= Date.StartOfWeek(Date.AddWeeks(Date.From(dtm_Now), -2)) and [Date]
            <= Date.From(dtm_Now),
          type logical
        ),
      add_InRecentMonth =
        Table.AddColumn(
          add_InRecentFortnight,
          "InRecentMonth",
          each
            [Date]
            >= Date.StartOfMonth(Date.AddMonths(Date.From(dtm_Now), -1)) and [Date]
            <= Date.From(dtm_Now),
          type logical
        ),
      add_InRecentQuarter =
        Table.AddColumn(
          add_InRecentMonth,
          "InRecentQuarter",
          each
            [Date]
            >= Date.StartOfQuarter(
              Date.AddQuarters(
                Date.From(dtm_Now),
                -1
              )
            ) and [Date]
            <= Date.From(dtm_Now),
          type logical
        ),
      add_InRecentYear =
        Table.AddColumn(
          add_InRecentQuarter,
          "InRecentYear",
          each
            [Date]
            >= Date.StartOfYear(Date.AddYears(Date.From(dtm_Now), -1)) and [Date]
            <= Date.From(dtm_Now),
          type logical
        ),
      add_InNextWeek =
        Table.AddColumn(
          add_InRecentYear,
          "InNextWeek",
          each
            [Date]
            <= Date.EndOfWeek(Date.AddWeeks(Date.From(dtm_Now), 1)) and [Date]
            >= Date.From(dtm_Now),
          type logical
        ),
      add_InNextFortnight =
        Table.AddColumn(
          add_InNextWeek,
          "InNextFortnight",
          each
            [Date]
            <= Date.EndOfWeek(Date.AddWeeks(Date.From(dtm_Now), 2)) and [Date]
            >= Date.From(dtm_Now),
          type logical
        ),
      add_InNextMonth =
        Table.AddColumn(
          add_InNextFortnight,
          "InNextMonth",
          each
            [Date]
            <= Date.EndOfMonth(Date.AddMonths(Date.From(dtm_Now), 1)) and [Date]
            >= Date.From(dtm_Now),
          type logical
        ),
      add_InNextQuarter =
        Table.AddColumn(
          add_InNextMonth,
          "InNextQuarter",
          each
            [Date]
            <= Date.EndOfQuarter(Date.AddQuarters(Date.From(dtm_Now), 1)) and [Date]
            >= Date.From(dtm_Now),
          type logical
        ),
      add_InNextYear =
        Table.AddColumn(
          add_InNextQuarter,
          "InNextYear",
          each
            [Date]
            <= Date.EndOfYear(Date.AddYears(Date.From(dtm_Now), 1)) and [Date]
            >= Date.From(dtm_Now),
          type logical
        ),
      add_BeforeToday = 
        Table.AddColumn(
          add_InNextYear,
          "BeforeToday",
          each [Date] < Date.From(dtm_Now),
          type logical
        ),
      add_OnOrBeforeToday =
        Table.AddColumn(
          add_BeforeToday,
          "OnOrBeforeToday",
          each [Date] <= Date.From(dtm_Now),
          type logical
        ),
      add_AfterToday = 
        Table.AddColumn(
          add_OnOrBeforeToday,
          "AfterToday",
          each [Date] > Date.From(dtm_Now),
          type logical
        ),
      add_OnOrAfterToday =
        Table.AddColumn(
          add_AfterToday,
          "OnOrAfterToday",
          each [Date] >= Date.From(dtm_Now),
          type logical
        ),
      add_FromStartOfPreviousWeek =
        Table.AddColumn(
          add_OnOrAfterToday,
          "FromStartOfPreviousWeek",
          each
            if
              [Date]
              < Date.StartOfWeek(Date.AddWeeks(Date.From(dtm_Now), -1))
            then
              false
            else
              true,
          type logical
        ),
      add_FromStartOfPreviousMonth =
        Table.AddColumn(
          add_FromStartOfPreviousWeek,
          "FromStartOfPreviousMonth",
          each
            if
              [Date]
              < Date.StartOfMonth(Date.AddMonths(Date.From(dtm_Now), -1))
            then
              false
            else
              true,
          type logical
        ),
      add_CompletedDay =
        Table.AddColumn(
          add_FromStartOfPreviousMonth,
          "CompletedDays",
          each
            if DateTime.Date(dtm_Now) > [Date] then
              "Y"
            else
              "N",
          type text
        ),
      add_CompletedWeek =
        Table.AddColumn(
          add_CompletedDay,
          "CompletedWeeks",
          each
            if
              (
                Date.Year(DateTime.Date(dtm_Now))
                > Date.Year([Date])
              )
            then
              "Y"
            else if
              (
                Date.Year(DateTime.Date(dtm_Now))
                < Date.Year([Date])
              )
            then
              "N"
            else if
              (
                Date.WeekOfYear(DateTime.Date(dtm_Now))
                > Date.WeekOfYear([Date])
              )
            then
              "Y"
            else
              "N",
          type text
        ),
      add_CompletedMonth =
        Table.AddColumn(
          add_CompletedWeek,
          "CompletedMonths",
          each
            if
              (
                Date.Year(DateTime.Date(dtm_Now))
                > Date.Year([Date])
              )
            then
              "Y"
            else if
              (
                Date.Year(DateTime.Date(dtm_Now))
                < Date.Year([Date])
              )
            then
              "N"
            else if
              (
                Date.Month(DateTime.Date(dtm_Now))
                > Date.Month([Date])
              )
            then
              "Y"
            else
              "N",
          type text
        ),
      add_CompletedQuarter =
        Table.AddColumn(
          add_CompletedMonth,
          "CompletedQuarters",
          each
            if
              (
                Date.Year(DateTime.Date(dtm_Now))
                > Date.Year([Date])
              )
            then
              "Y"
            else if
              (
                Date.Year(DateTime.Date(dtm_Now))
                < Date.Year([Date])
              )
            then
              "N"
            else if
              (
                Date.QuarterOfYear(DateTime.Date(dtm_Now))
                > Date.QuarterOfYear([Date])
              )
            then
              "Y"
            else
              "N",
          type text
        ),
      add_CompletedYear =
        Table.AddColumn(
          add_CompletedQuarter,
          "CompletedYears",
          each
            if
              (
                Date.Year(DateTime.Date(dtm_Now))
                > Date.Year([Date])
              )
            then
              "Y"
            else
              "N",
          type text
        ),
      add_DayType =
        Table.AddColumn(
          add_CompletedYear,
          "DayType",
          each
            if [PreviousWorkingDay] = true then
              "Previous"
            else if [CurrentDay] = true then
              "Current"
            else if [NextWorkingDay] = true then
              "Next"
            else
              null,
          type text
        ),
      Sort = Table.Sort(add_DayType, {{"Date", Order.Ascending}})
    in
      Sort
in
  Table.GenerateDateTable