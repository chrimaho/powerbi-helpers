PowerBI-Helpers

This repo is a consolidation of many different `M` functions, to enhance and extend the capability of PowerQuery, and PowerBI more broadly.

## Usage

### Manual

Due to PowerQuery's inability to import external modules (😩), these will need to be loaded manually.

> 1. Locate the function you would like to use in this library.
> 2. Copy all of the code within the `*.pq` file.
> 3. Go to PowerQuery, and create a new blan query: `Home` > `New Source` > `Blank Query`.
> 4. Open the Advanced Editor: `View` > `Advanced Editor`.
> 5. Replace all the code with what was copied from the `*.pq` file.
> 6. Press `Done`.
> 7. Use the function.

### Semi-Automatic

Using the process defined [here](https://stackoverflow.com/questions/57232378/store-power-query-custom-function-online-github-etc-and-call-it), you can pull the source code directly from the GitHub repository.

My testing shows that this method works well on both PowerQuery with PowerBI Desktop, and PowerQuery with Excel, and PowerQuery with PowerBI DataFlows.

> 1. Location the function you'd like to use in this library.
> 2. Open the "Raw" file.<br>
>    ![](https://i.stack.imgur.com/n9Onf.png)
> 3. Copy the URL.
> 4. Go to PowerQuery and open a new _Blank_ query<br>
>    ![](https://learn.microsoft.com/en-us/power-bi/transform-model/media/desktop-query-overview/query-overview-new-source-menu.png)
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
>    ![](https://i.stack.imgur.com/vAzy6.png)

## Function Documentation

I've tried to document some functions (like, for example, [`fun_AddPrimaryKeyFromListOfColumns.pq`](/PowerQuery/Functions/Tables/fun_AddPrimaryKeyFromListOfColumns.pq)). However, adding function docs in PowerQuery is (quite frankly) very messy... for more info, see [here](https://docs.microsoft.com/en-us/power-query/handlingdocumentation) and [here](https://bengribaudo.com/blog/2021/03/17/5523/power-query-m-primer-part20-metadata). It's on my to-do list to add some helpful docs for each function, plus some examples of how to implement them. But I haven't quite found the time for this just yet. Any help from the Open Source Community would be fantastic! 😁

## Other Repo's

The [`Repos/`](Repos/) directory contains a lot of sub-modules from other Repo's available on the internet. These are only small few of the ones that are available on line. And there's soooo much good stuff in there! 👍 Enjoy!

## Project Structure

The [`GenericFolderStructure/`](GenericFolderStructure/) directory is the structure that I like to have in my PowerQuery environment. It helps to improve the layout and standard structure of my projects. This should become best practice.

## Contribution

Contributions are welcome. Please [Fork](https://docs.github.com/en/get-started/quickstart/fork-a-repo) the repo and submit a [Pull Request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request-from-a-fork) for any updates that you'd like to make.