let
  fun_GetFunction = (
    txt_UrlOrName as text,
    optional txt_Method as nullable text,
    optional txt_BaseUrl as nullable text
  ) as function =>
    let
      Method = 
        if List.Contains({null, ""}, txt_Method) then
          if Text.Contains(Text.Lower(txt_UrlOrName), "http")
          then Text.Lower("url")
          else Text.Lower("name")
        else if List.Contains({"url", "name"}, Text.Lower(txt_Method)) then Text.Lower(txt_Method)
        else error "'txt_Method' must be one of: 'URL' or 'Name'. No other value is accepted.",
      BaseURL = 
        if List.Contains({null, ""}, txt_BaseUrl)
        then "https://raw.githubusercontent.com/chrimaho/powerbi-helpers/main/PowerQuery/Functions/"
        else txt_BaseUrl,
      URL = 
        if Method = "url" then txt_UrlOrName
        else if Method = "name" then Text.Combine({BaseURL, if Text.EndsWith(BaseURL, "/") then "" else "/", txt_UrlOrName, if Text.EndsWith(txt_UrlOrName, ".pq") then "" else ".pq"}, "")
        else txt_UrlOrName,
      Web = Web.Contents(URL),
      Text = Text.FromBinary(Web),
      Expression = Expression.Evaluate(Text, #shared)
    in
      Expression
in
  fun_GetFunction