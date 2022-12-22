let
    fun_ReplaceTextBetweenDelimiters =
        (Text as text, StartDelimiter as text, EndDelimiter as text, optional ReplaceDelimiters as nullable logical, optional NewText as nullable text, optional TrimResult as nullable logical, optional FixDoubleSpaces as nullable logical) as text =>
            let
                // Add Default Parameters
                Default_ReplaceDelimiters =
                    if ReplaceDelimiters is null then
                        true
                    else
                        ReplaceDelimiters,
                Default_NewText =
                    if NewText is null then
                        ""
                    else
                        NewText,
                Default_TrimResult =
                    if TrimResult is null then
                        true
                    else
                        TrimResult,
                Default_FixDoubleSpaces =
                    if FixDoubleSpaces is null then
                        true
                    else
                        FixDoubleSpaces,
                //Do work
                TextBetweenDelimiters =
                    Text.BetweenDelimiters(
                        Text,
                        StartDelimiter,
                        EndDelimiter
                    ),
                TextToReplace =
                    if Default_ReplaceDelimiters then
                        Text.Combine(
                            {
                                StartDelimiter,
                                TextBetweenDelimiters,
                                EndDelimiter
                            }
                        )
                    else
                        TextBetweenDelimiters,
                ReplacedText =
                    Text.Replace(
                        Text,
                        TextToReplace,
                        Default_NewText
                    ),
                //Clean Result
                TrimmedText =
                    if Default_TrimResult then
                        Text.Trim(ReplacedText)
                    else
                        ReplacedText,
                FixedSpaces =
                    if Default_FixDoubleSpaces then
                        Text.Replace(TrimmedText, "  ", " ")
                    else
                        TrimmedText
            in
                FixedSpaces
in
    fun_ReplaceTextBetweenDelimiters