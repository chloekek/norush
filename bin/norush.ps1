param (
    # Path to a file that contains the OAuth token to use for authenticating
    # with GitHub.
    [string] $OauthTokenPath,

    # The owner and name of the repository to monitor.
    [string] $RepoOwner,
    [string] $RepoName,

    # When a pull request has a label with this name, it is considered for
    # merging.
    [string] $RequestedMergeLabel,

    # The directory that contains the repository. The repository must have a
    # remote called origin.
    [string] $Repository
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$OauthToken = Get-Content $OauthTokenPath
$Github = Open-GithubClient($OauthToken)

$PullRequests = Get-PullRequestsRequestedMerge $GitHub $RepoOwner $RepoName
$Branches = $PullRequests | % { $_.Base, $_.Head } | Sort-Object | Get-Unique

With-Location $Repository {
    # TODO: Gracefully handle Git commands failing. Do not leave the repository
    # in a dirty state.

    git fetch

    $Branches | % {
        Write-Output "RESET $_ -> origin/$_"
        git checkout $_
        git clean -fd
        git reset --hard "origin/$_"
    }

    $PullRequests | % {
        Write-Output "REBASE #$($_.Number) @ $($_.Head) -> $($_.Base)"
        git checkout $_.Head
        git rebase $_.Base
        git push --force-with-lease origin $_.Head

        # TODO: Only merge if the rebase was a no-op. Otherwise, skip the merge
        # since we need to wait for CI.

        # TODO: Only merge if CI is good.

        Write-Output "MERGE #$($_.Number) @ $($_.Head) -> $($_.Base)"
        git checkout $_.Base
        git merge --no-edit --no-ff $_.Head
        git push origin $_.Base
    }
}
