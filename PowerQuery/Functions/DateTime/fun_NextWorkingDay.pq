let
    fun_NextWorkingDay =
        (dat_Date as date) as date =>
            let
                today = Date.From(dat_Date),
                d = Date.DayOfWeek(today, Day.Monday)
            in
                if d = 4 then
                    Date.AddDays(today, +3)
                else if d = 5 then
                    Date.AddDays(today, +2)
                else
                    Date.AddDays(today, +1)
in
    fun_NextWorkingDay