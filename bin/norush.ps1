param (
    # Path to a file that contains the OAuth token to use for authenticating
    # with GitHub.
    [Parameter(Mandatory)] [string] $OauthTokenPath,

    # The owner and name of the repository to monitor.
    [Parameter(Mandatory)] [string] $RepoOwner,
    [Parameter(Mandatory)] [string] $RepoName,

    # When a pull request has a label with this name, it is considered for
    # merging.
    [Parameter(Mandatory)] [string] $RequestedMergeLabel,

    # The directory that contains the repository. The repository must have a
    # remote called origin.
    [Parameter(Mandatory)] [string] $Repository
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$OauthToken = Get-Content $OauthTokenPath
$Github = Open-GithubClient($OauthToken)

$PullRequests = Get-PullRequestsRequestedMerge $GitHub $RepoOwner $RepoName
$Branches = $PullRequests | % { $_.Base, $_.Head } | Sort-Object | Get-Unique

With-Location $Repository {
    # TODO: Handle errors thrown by Git-* functions.

    Write-Output "FETCH"
    Git-Fetch

    $Branches | % {
        Write-Output "RESET $_"
        Git-Reset $_
    }

    $PullRequests | % {
        Write-Output "REBASE #$($_.Number) @ $($_.Head) -> $($_.Base)"
        Git-Rebase $_.Base $_.Head

        # TODO: Only merge if the rebase was a no-op. Otherwise, skip the merge
        # since we need to wait for CI.

        # TODO: Only merge if CI is good.

        Write-Output "MERGE #$($_.Number) @ $($_.Head) -> $($_.Base)"
        Git-Merge $_.Base $_.Head
    }
}
