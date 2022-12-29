let
  fun_RoundTime = (
    DateTimeToRound as any,
    optional TimeInterval as nullable text,
    optional RoundingInterval as nullable number,
    optional RoundingDirection as nullable text
  ) as time =>
    let

      /* Notes:
        - 'TimeInterval' should be one of: 'Hour', 'Minute', 'Second'.
        - 'RoundingInterval' is for rounding to nearest minute, nearest 5 minutes, nearest 15 minutes, etc...
        - 'RoundingDirection' should be one of: 'Up', 'Down', 'Nearest' or 'null'. If 'null', it will default to 'Nearest'.
      */

      // Validate 'TimeInterval'
      tmp_TimeInterval =
        if List.Contains({null, ""}, TimeInterval) then Text.Proper("Minute")
        else if List.Contains({"Hour","Minute","Second"}, Text.Proper(TimeInterval)) then Text.Proper(TimeInterval)
        else error "'TimeInterval' must be one of: 'Hour','Minute','Second'. No other values are accepted.",

      // Validate 'RoundingDirection'
      tmp_RoundingDirection =
        if List.Contains({null, ""}, RoundingDirection) then "Nearest"
        else if List.Contains({"Up","Down","Nearest"}, Text.Proper(RoundingDirection)) then Text.Proper(RoundingDirection)
        else error "'RoundingDirection' must be one of: 'Up','Down','Nearest' or 'null'.",

      // Set source
      Source = DateTimeToRound,

      // Make function round to nearest minute by default
      Rounding =
        if List.Contains({null, ""}, RoundingInterval) then 1
        else RoundingInterval,

      // Convert datetime to decimal: Convert to number of days since 30/12/1899. Decimal component stores the time component of the datetime
      TimeDecimal = Number.From(Source),

      // Convert number from representing days to representing minutes. Default rounding is to the minute.
      TimeConverted =
        if tmp_TimeInterval = "Hour" then TimeDecimal * (24 / Rounding)
        else if tmp_TimeInterval = "Minute" then TimeDecimal * (24 * 60 / Rounding)
        else if tmp_TimeInterval = "Second" then TimeDecimal * (24 * 60 * 60 / Rounding)
        else TimeDecimal * (24 * 60 / Rounding),

      // Round it
      RoundedTime =
        if tmp_RoundingDirection = "Nearest" then Number.Round(TimeConverted)
        else if tmp_RoundingDirection = "Up" then Number.RoundUp(TimeConverted)
        else if tmp_RoundingDirection = "Down" then Number.RoundDown(TimeConverted)
        else Number.Round(TimeConverted),

      // Convert back to days since 30/12/1899
      TimeConvertedBack =
        if tmp_TimeInterval = "Hour" then RoundedTime / (24 / Rounding)
        else if tmp_TimeInterval = "Minute" then RoundedTime / (24 * 60 / Rounding)
        else if tmp_TimeInterval = "Second" then RoundedTime / (24 * 60 * 60 / Rounding)
        else RoundedTime / (24 * 60 / Rounding),

      // Finalise
      TimeFinal = Time.From(TimeConvertedBack)

    in
      TimeFinal
in
  fun_RoundTime
