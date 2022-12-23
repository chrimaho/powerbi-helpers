# PowerBI-Helpers

This repo is a consolidation of many different `M` functions, to enhance and extend the capability of PowerQuery, and PowerBI more broadly.

## Details

When working with PowerBI, and in particular PowerQuery, we find that there are many functions available. However, as developers, we may want to extend the functionality of the core language, and add more convenience functions and to extend the functionality to meet our needs. This is not only advised by Microsoft, but openly encouraged (see more info [here][1], [here][2], [here][3], [here][4], and [here][6]). Here, I've tried to collate and share some of the main ones that I use very regularly.

[1]: https://learn.microsoft.com/en-us/power-query/best-practices
[2]: https://support.microsoft.com/en-us/office/create-and-invoke-a-custom-function-5dcedf5f-45a5-4dd7-b8f4-4d35c386d712
[3]: https://learn.microsoft.com/en-us/power-query/custom-function
[4]: https://radacad.com/custom-functions-made-easy-in-power-bi-desktop
[5]: https://learn.microsoft.com/en-us/power-query/dataflows/best-practices-developing-complex-dataflows

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

Using the process defined [here][6], you can pull the source code directly from the GitHub repository.

[6]: https://stackoverflow.com/questions/57232378/store-power-query-custom-function-online-github-etc-and-call-it

My testing shows that this method works well on both PowerQuery with PowerBI Desktop, and PowerQuery with Excel, and PowerQuery with PowerBI DataFlows.

> 1. Location the function you'd like to use in this library.
> 2. Open the "Raw" file.<br>
>    ![][7]
> 3. Copy the URL.
> 4. Go to PowerQuery and open a new _Blank_ query<br>
>    ![][8]
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
>    ![][9]

[7]: https://i.stack.imgur.com/n9Onf.png
[8]: https://learn.microsoft.com/en-us/power-bi/transform-model/media/desktop-query-overview/query-overview-new-source-menu.png
[9]: https://i.stack.imgur.com/vAzy6.png

## Function Documentation

I've tried to document some functions (like, for example, [`fun_AddPrimaryKeyFromListOfColumns.pq`][10]). However, adding function docs in PowerQuery is (quite frankly) very messy 😫... for more info, see [here][11] and [here][12]. It's on my to-do list to add some helpful docs for each function, plus some examples of how to implement them. But I haven't quite found the time for this just yet. Any help from the Open Source Community would be fantastic! 😁

[10]: /PowerQuery/Functions/Tables/fun_AddPrimaryKeyFromListOfColumns.pq
[11]: https://docs.microsoft.com/en-us/power-query/handlingdocumentation
[12]: https://bengribaudo.com/blog/2021/03/17/5523/power-query-m-primer-part20-metadata

## Other Repo's

The [`Repos/`](Repos/) directory contains a lot of sub-modules from other Repo's available on the internet. These are only small few of the ones that are available on line. And there's soooo much good stuff in there! 👍 Enjoy!

## Project Structure

The [`GenericFolderStructure/`](GenericFolderStructure/) directory is the structure that I like to have in my PowerQuery environment. It helps to improve the layout and standard structure of my projects. This should become best practice.

## Contribution

Contributions are welcome. Please [Fork][13] the repo and submit a [Pull Request][14] for any updates that you'd like to make.

[13]: https://docs.github.com/en/get-started/quickstart/fork-a-repo
[14]: https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request-from-a-fork
