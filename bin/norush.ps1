param (
    # Path to the Octokit library as produced by nix/octokit.nix. This
    # parameter is automatically supplied by the wrapper generated in
    # default.nix.
    [string] $OctokitPath,

    # Path to a file that contains the OAuth token to use for authenticating
    # with GitHub.
    [string] $OauthTokenPath,

    # The owner and name of the repository to monitor.
    [string] $RepoOwner,
    [string] $RepoName,

    # When a pull request has a label with this name, it is considered for
    # merging.
    [string] $RequestedMergeLabel
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Add-Type -Path "$OctokitPath/lib/Octokit.dll"

$UserAgent = [Octokit.ProductHeaderValue]::new("norush")
$GitHub = [Octokit.GitHubClient]::new($UserAgent)

$OauthToken = Get-Content $OauthTokenPath
$Credentials = [Octokit.Credentials]::new($OauthToken)
$GitHub.Credentials = $Credentials

Write-Output "Pull requests requested to merge:"
Get-PullRequestsRequestedMerge $GitHub $RepoOwner $RepoName `
    | % { Write-Output "#$($_.Number) @ $($_.Head) -> $($_.Base)" }
