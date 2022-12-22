let
    fun_DateTimeToUnix = (optional DateTime as nullable datetime) as number =>
        let
            default_DateTime = if DateTime is null then DateTime.From(DateTimeZone.UtcNow()) else DateTime,
            UnixDateTime = Duration.TotalSeconds(default_DateTime - DateTime.FromText("1/1/1970"))
        in
            UnixDateTime
in
    fun_DateTimeToUnix