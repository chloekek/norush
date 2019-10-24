@{
    ModuleVersion = "0.0.0.0";
    NestedModules = @(
        "./Monitor.ps1"
    );
    FunctionsToExport = @(
        "Get-PullRequestsRequestedMerge"
    )
}
