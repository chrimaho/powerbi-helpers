let
    fun_GetDataFlowTable_ByID =
        (optional WorkSpaceId as nullable text, optional DataFlowId as nullable text, optional EntityName as nullable text) as table =>
            let
                Source = PowerPlatform.Dataflows([]),
                Workspaces = Source{[Id = "Workspaces"]}[Data],
                WorkSpace =
                    if WorkSpaceId <> null then
                        Workspaces{[workspaceId = WorkSpaceId]}[Data]
                    else
                        null,
                DataFlow =
                    if
                        WorkSpaceId
                        <> null and DataFlowId
                        <> null
                    then
                        WorkSpace{[dataflowId = DataFlowId]}[Data]
                    else
                        null,
                Entity =
                    if
                        Workspaces
                        <> null and DataFlowId
                        <> null and EntityName
                        <> null
                    then
                        DataFlow{[entity = EntityName]}[Data]
                    else
                        null
            in
                if
                    WorkSpaceId
                    is null and DataFlowId
                    is null and EntityName
                    is null
                then
                    Workspaces
                else if
                    WorkSpaceId
                    <> null and DataFlowId
                    is null and EntityName
                    is null
                then
                    WorkSpace
                else if
                    WorkSpaceId
                    <> null and DataFlowId
                    <> null and EntityName
                    is null
                then
                    DataFlow
                else if
                    WorkSpaceId
                    <> null and DataFlowId
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
    fun_GetDataFlowTable_ByID