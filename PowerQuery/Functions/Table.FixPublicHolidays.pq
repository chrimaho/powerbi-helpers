let
  Table.FixPublicHolidays = (
    Table as record
  ) as table =>
    let
      JSON = Table,
      Fields =
        Table.Column(
          Table.ExpandRecordColumn(
            Table.FromList(
              JSON[fields],
              Splitter.SplitByNothing()
            ),
            "Column1",
            {
              "id",
              "type"
            }
          ),
          "id"
        ),
      Records =
        Table.ExpandRecordColumn(
          Table.FromList(
            JSON[records],
            Splitter.SplitByNothing()
          ),
          "Column1",
          Fields
        ),
      RemoveCols =
        try
          Table.RemoveColumns(
            Records,
            {
              "_full_text",
              "_id"
            }
          )
        otherwise Records
    in
        RemoveCols
in
  Table.FixPublicHolidays