let
    fun_ReadableSizeFromBytes = (bytes as number) as text =>
        let
            Source = bytes,
            Convert = 
                if Source < 1024 then Text.Combine({Number.ToText(Source), "B"}, " ")
                else if Source < 1024*1024 then Text.Combine({Number.ToText(Number.Round(Source/1024, 2)), "KB"}, " ")
                else if Source < 1024*1024*1024 then Text.Combine({Number.ToText(Number.Round(Source/1024/1024, 2)), "MB"}, " ")
                else Text.Combine({Number.ToText(Number.Round(Source/1024/1024/1024, 2)), "GB"}, " ")
        in
            Convert
in
    fun_ReadableSizeFromBytes