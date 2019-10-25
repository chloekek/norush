@{
    ModuleVersion = "0.0.0.0";
    NestedModules = @(
        "./Github.ps1",
        "./Monitor.ps1",
        "./Utility.ps1"
    );
    FunctionsToExport = @(
        "Get-PullRequestsRequestedMerge",
        "Open-GithubClient",
        "With-Location"
    )
}
