let
    fun_GetDateTimeNowAtZone =
        (ApiKey as text, TimeZone as text) as datetime =>
            let
                Web =
                    Web.Contents(
                        "http://api.timezonedb.com/v2/get-time-zone",
                        [
                            Timeout = #duration(0, 0, 1, 0),
                            Query = [
                                key = ApiKey,
                                format = "xml",
                                by = "zone",
                                zone = TimeZone
                            ]
                        ]
                    ),
                XML = Xml.Document(Web),
                tbl_Data = XML{[Name = "result"]}[Value],
                tbl_Buffer = Table.Buffer(tbl_Data),
                str_DateTime = tbl_Buffer{[Name = "formatted"]}[Value],
                bin_Buffer = Text.FromBinary(Binary.Buffer(Text.ToBinary(str_DateTime))),
                dtm_DateTime = DateTime.From(bin_Buffer)
            in
                dtm_DateTime
in
    fun_GetDateTimeNowAtZone