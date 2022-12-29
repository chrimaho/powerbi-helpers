let
  DateTime.ConvertTimeZones = (
    ToTimeZone as text,
    optional FromTimeZone as nullable text,
    optional FromDateTime as nullable datetime,
    optional ReturnDetails as nullable logical
  ) as any =>
    let
      /* Notes:
        - This will call the API endpoint for: http://api.timezonedb.com/v2.1/convert-time-zone
        - For docs & details, see: https://timezonedb.com/references/convert-time-zone
        - NOTE: You must use an official API key.
          - To register for a free key, see: https://timezonedb.com/register
          - Once you have the key, create one parameter called `prm_TimeZoneDb_ApiKey`, and paste your API key in there.
        - Parameters:
          - `ToTimeZone` is required. You can use the abbreviated name (eg. `AEDT`), or the extended name (eg. `Australia/Sydney`); both will work.
          - `FromTimeZone` is optional. If not provided, then the `UTC` Time Zone will be used. Will also accept either abbreviated or extended name.
          - `FromDateTime` is optional. If not provided, will use `UTC` time as at the time the function is invoked.
          - `ReturnDetails` is optional. If not provided, will use `false`.
        - Returns:
          - When `ReturnDetails` is `true`, it will return a table containing all relevant information for the `FromDateTime` and `ToDateTime` values.
          - When `ReturnDetails` is `false`, it will only return the DateTime values for the requested `ToTimeZone`.
      */
      default_FromTimeZone = if FromTimeZone is null then "UTC" else FromTimeZone,
      default_FromDateTime = if FromDateTime is null then DateTime.From(DateTimeZone.UtcNow()) else FromDateTime,
      default_ReturnDetails = if ReturnDetails is null then false else ReturnDetails,
      FromDateTimeUnix = Text.From(fun_DateTimeToUnix(default_FromDateTime)),
      Web = Web.Contents(
        "http://api.timezonedb.com/v2.1/convert-time-zone",
        [
          Timeout=#duration(0,0,1,0),
          Query=[
            key=prm_TimeZoneDb_ApiKey,
            format="xml",
            from=default_FromTimeZone,
            to=ToTimeZone,
            time=FromDateTimeUnix
          ]
        ]
      ),
      XML = Xml.Document(Web),
      Data = XML{[Name = "result"]}[Value],
      Select = Table.RemoveColumns(Data,{"Namespace", "Attributes"}),
      Filter = Table.SelectRows(Select, each ([Name] <> "message" and [Name] <> "status")),
      Pivot = Table.Pivot(Filter, List.Distinct(Filter[Name]), "Name", "Value"),
      Types = Table.TransformColumnTypes(Pivot,{{"fromZoneName", type text}, {"fromAbbreviation", type text}, {"toZoneName", type text}, {"toAbbreviation", type text}, {"fromTimestamp", Int64.Type}, {"toTimestamp", Int64.Type}, {"offset", Int64.Type}}),
      Rename = Table.RenameColumns(Types, {{"fromTimestamp", "fromTimestamp_Unix"}, {"toTimestamp", "toTimestamp_Unix"}, {"offset", "offset_Seconds"}}),
      add_FromDateTime = Table.AddColumn(Rename, "fromDateTime", each fun_DateTimeFromUnix([fromTimestamp_Unix]), type datetime),
      add_ToDateTime = Table.AddColumn(add_FromDateTime, "toDateTime", each fun_DateTimeFromUnix([toTimestamp_Unix]), type datetime),
      Reorder = Table.ReorderColumns(add_ToDateTime,{"fromZoneName", "fromAbbreviation", "fromTimestamp_Unix", "fromDateTime", "toZoneName", "toAbbreviation", "toTimestamp_Unix", "toDateTime", "offset_Seconds"}),
      Return = if default_ReturnDetails then Reorder else Reorder{0}[toDateTime]
    in
      Return
in
  DateTime.ConvertTimeZones
