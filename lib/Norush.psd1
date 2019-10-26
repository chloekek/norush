@{
    ModuleVersion = "0.0.0.0";
    NestedModules = @(
        "./Git.ps1",
        "./Github.ps1",
        "./Monitor.ps1",
        "./Utility.ps1"
    );
    FunctionsToExport = @(
        "Get-PullRequestsRequestedMerge",
        "Git-CanFastForward",
        "Git-Fetch",
        "Git-Merge",
        "Git-Rebase",
        "Git-Reset",
        "Open-GithubClient",
        "With-Location"
    )
}
