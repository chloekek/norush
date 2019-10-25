# Get all pull requests that are requested to be merged and are still open, in
# the given repository.
function Get-PullRequestsRequestedMerge {
    param (
        [Octokit.GitHubClient] $Github,
        [string] $RepoOwner,
        [string] $RepoName
    )
    $Request = $Github.PullRequest.GetAllForRepository($RepoOwner, $RepoName)
    $Request.GetAwaiter().GetResult() `
        | % {
            $Labels = $_.Labels | % { $_.Name }
            $RequestedMerge = $Labels -contains $RequestedMergeLabel
            @{ Number         = $_.Number
               IsOpen         = $_.State -eq [Octokit.ItemState]::Open
               Base           = $_.Base.Ref
               Head           = $_.Head.Ref
               RequestedMerge = $RequestedMerge }
        } `
        | ? { $_.RequestedMerge -and $_.IsOpen } `
        | Sort-Object -Property Number
}
