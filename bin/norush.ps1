param (
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

$OauthToken = Get-Content $OauthTokenPath
$Github = Open-GithubClient($OauthToken)

Write-Output "Pull requests requested to merge:"
Get-PullRequestsRequestedMerge $GitHub $RepoOwner $RepoName `
    | % { Write-Output "#$($_.Number) @ $($_.Head) -> $($_.Base)" }
