let
  Date.GetPreviousWorkingDay = (
    dat_Date as date
  ) as date =>
    let
      today = Date.From(dat_Date),
      d = Date.DayOfWeek(today, Day.Monday)
    in
      if d = 6 then
        Date.AddDays(today, -2)
      else if d = 0 then
        Date.AddDays(today, -3)
      else
        Date.AddDays(today, -1)
in
  Date.GetPreviousWorkingDay