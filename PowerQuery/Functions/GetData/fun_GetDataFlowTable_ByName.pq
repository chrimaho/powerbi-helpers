let
    fun_GetDataFlowTable_ByName =
        (optional WorkSpaceName as nullable text, optional DataFlowName as nullable text, optional EntityName as nullable text) as table =>
            let
                Source = PowerPlatform.Dataflows([]),
                Workspaces = Source{[Id = "Workspaces"]}[Data],
                WorkSpace =
                    if WorkSpaceName <> null then
                        Workspaces{[workspaceName = WorkSpaceName]}[Data]
                    else
                        null,
                DataFlow =
                    if
                        WorkSpaceName
                        <> null and DataFlowName
                        <> null
                    then
                        WorkSpace{[dataflowName = DataFlowName]}[Data]
                    else
                        null,
                Entity =
                    if
                        Workspaces
                        <> null and DataFlowName
                        <> null and EntityName
                        <> null
                    then
                        DataFlow{[entity = EntityName]}[Data]
                    else
                        null
            in
                if
                    WorkSpaceName
                    is null and DataFlowName
                    is null and EntityName
                    is null
                then
                    Workspaces
                else if
                    WorkSpaceName
                    <> null and DataFlowName
                    is null and EntityName
                    is null
                then
                    WorkSpace
                else if
                    WorkSpaceName
                    <> null and DataFlowName
                    <> null and EntityName
                    is null
                then
                    DataFlow
                else if
                    WorkSpaceName
                    <> null and DataFlowName
                    <> null and EntityName
                    <> null
                then
                    Entity
                else
                    #table(
                        {"Error"},
                        {"There was an error"}
                    )
in
    fun_GetDataFlowTable_ByName