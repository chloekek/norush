# Get all pull requests that are requested to be merged and are not already
# merged, in the given repository.
function Get-PullRequestsRequestedMerge {
    param (
        [Octokit.GitHubClient] $GitHub,
        [string] $RepoOwner,
        [string] $RepoName
    )
    $Request = $GitHub.PullRequest.GetAllForRepository($RepoOwner, $RepoName)
    $Request.GetAwaiter().GetResult() `
        | % {
            $Labels = $_.Labels | % { $_.Name }
            $RequestedMerge = $Labels -contains $RequestedMergeLabel
            @{ Number         = $_.Number
               Merged         = $_.Merged
               Base           = $_.Base.Ref
               Head           = $_.Head.Ref
               RequestedMerge = $RequestedMerge }
        } `
        | ? { $_.RequestedMerge -and !$_.Merged } `
        | Sort-Object -Property Number
}
