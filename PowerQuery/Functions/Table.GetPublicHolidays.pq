let
  Table.GetPublicHolidays = (
    Period as text
  ) as table =>
    let
      Key = tbl_PublicHolidayKeys{[Period = Period]}[Resource_ID],
      URL = "https://data.gov.au/data/api/3/action/datastore_search_sql",
      Query =
        Text.Combine(
          {
            "SELECT * FROM """,
            Key,
            """"
          }
        ),
      Web =
        Web.Contents(
          URL,
          [
            Timeout = #duration(0, 1, 0, 0),
            Query = [
              sql = Query
            ]
          ]
        ),
      JSON = Json.Document(Web)[result],
      Data = fun_FixPublicHolidays(JSON)
    in
      Data
in
  Table.GetPublicHolidays