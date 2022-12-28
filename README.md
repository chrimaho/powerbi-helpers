# PowerBI-Helpers

This repo is a consolidation of many different `M` functions, to enhance and extend the capability of PowerQuery, and PowerBI more broadly.

## Details

When working with [PowerBI][pbi-overview], and in particular [PowerQuery][pq-overview], we find that there are many functions available. However, as developers, we may want to extend the functionality of the core language, and add more convenience functions and to extend the functionality to meet our needs. This is not only advised by Microsoft, but openly encouraged (see more info [here][pq-best-practices], [here][pq-create-custom-functions], [here][pq-custom-functions], [here][pq-functions-made-easy], and [here][df-best-practices]). Here, I've tried to collate and share some of the main ones that I use very regularly.

[pbi-overview]: https://learn.microsoft.com/en-us/power-bi/fundamentals/power-bi-overview
[pq-overview]: https://learn.microsoft.com/en-us/power-query/power-query-what-is-power-query
[pq-best-practices]: https://learn.microsoft.com/en-us/power-query/best-practices
[pq-create-custom-functions]: https://support.microsoft.com/en-us/office/create-and-invoke-a-custom-function-5dcedf5f-45a5-4dd7-b8f4-4d35c386d712
[pq-custom-functions]: https://learn.microsoft.com/en-us/power-query/custom-function
[pq-functions-made-easy]: https://radacad.com/custom-functions-made-easy-in-power-bi-desktop
[df-best-practices]: https://learn.microsoft.com/en-us/power-query/dataflows/best-practices-developing-complex-dataflows

## Usage

### Manual

Due to PowerQuery's inability to import external modules (😩), these will need to be loaded manually.

> 1. Locate the function you would like to use in this library.
> 2. Copy all of the code within the `*.pq` file.
> 3. Go to PowerQuery, and create a new blan query: `Home`>`New Source`>`Blank Query`.
> 4. Open the Advanced Editor: `View`>`Advanced Editor`.
> 5. Replace all the code with what was copied from the `*.pq` file.
> 6. Press `Done`.
> 7. Use the function.

### Semi-Automatic

Using the process defined [here][pq-calling-online-functions], you can pull the source code directly from the GitHub repository.

[pq-calling-online-functions]: https://stackoverflow.com/questions/57232378/store-power-query-custom-function-online-github-etc-and-call-it

My testing shows that this method works well on both PowerQuery with PowerBI Desktop, and PowerQuery with Excel, and PowerQuery with PowerBI DataFlows.

> 1. Location the function you'd like to use in this library.
> 2. Open the "Raw" file.<br>
>    ![][get-raw-code]
> 3. Copy the URL.
> 4. Go to PowerQuery and open a new _Blank_ query<br>
>    ![][new-blank-query]
> 5. Change the function to look like this:<br>
>    ```fs
>    Expression.Evaluate(Text.FromBinary(Web.Contents(<PasteTheUrlHere>)),#shared)
>    ```
>    For example:
>    ```fs
>    let
>        Source = Expression.Evaluate(Text.FromBinary(Web.Contents("https://raw.githubusercontent.com/chrimaho/powerbi-helpers/main/PowerQuery/Functions/Conversions/fun_ReadableSizeFromBytes.pq")),#shared)
>    in
>        Source
>    ```
> 6. Which will give you the result as expected:<br>
>    ![][query-result]

[get-raw-code]: https://i.stack.imgur.com/n9Onf.png
[new-blank-query]: https://learn.microsoft.com/en-us/power-bi/transform-model/media/desktop-query-overview/query-overview-new-source-menu.png
[query-result]: https://i.stack.imgur.com/vAzy6.png

## Function Documentation

I've tried to document some functions (like, for example, [`fun_AddPrimaryKeyFromListOfColumns.pq`][pq-function-with-docs]). However, adding function docs in PowerQuery is (quite frankly) very messy 😫... for more info, see [here][pq-function-documentation] and [here][pq-metadata-primer]. It's on my to-do list to add some helpful docs for each function, plus some examples of how to implement them. But I haven't quite found the time for this just yet. Any help from the Open Source Community would be fantastic! 😁

[pq-function-with-docs]: /PowerQuery/Functions/Tables/fun_AddPrimaryKeyFromListOfColumns.pq
[pq-function-documentation]: https://docs.microsoft.com/en-us/power-query/handlingdocumentation
[pq-metadata-primer]: https://bengribaudo.com/blog/2021/03/17/5523/power-query-m-primer-part20-metadata

## Other Repo's

The [`Repos/`](Repos/) directory contains a lot of sub-modules from other Repo's available on the internet. These are only small few of the ones that are available on line. And there's soooo much good stuff in there! 👍 Enjoy!

## Project Structure

The [`GenericFolderStructure/`](GenericFolderStructure/) directory is the structure that I like to have in my PowerQuery environment. It helps to improve the layout and standard structure of my projects. This should become best practice.

## Contribution

Contributions are welcome. Please [Fork][gh-fork-a-repo] the repo and submit a [Pull Request][gh-submit-pull-request] for any updates that you'd like to make.

[gh-fork-a-repo]: https://docs.github.com/en/get-started/quickstart/fork-a-repo
[gh-submit-pull-request]: https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request-from-a-fork
