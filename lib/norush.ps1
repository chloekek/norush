param (
    # Path to the Octokit library as produced by nix/octokit.nix. This
    # parameter is automatically supplied by the wrapper generated in
    # default.nix.
    [string] $OctokitPath,

    # Path to a file that contains the OAuth token to use for authenticating
    # with GitHub.
    [string] $OauthTokenPath,

    # The name of the label that signals that a pull request is eligible for
    # merging.
    [string] $EligibleLabel
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Get-Result($task) {
    $task.GetAwaiter().GetResult()
}

Add-Type -Path "$OctokitPath/lib/Octokit.dll"

$UserAgent = [Octokit.ProductHeaderValue]::new("norush")
$GitHub = [Octokit.GitHubClient]::new($UserAgent)

$OauthToken = Get-Content $OauthTokenPath
$Credentials = [Octokit.Credentials]::new($OauthToken)
$GitHub.Credentials = $Credentials

function Get-EligiblePullRequests([string] $Owner, [string] $Repo) {
    $Request = $GitHub.PullRequest.GetAllForRepository($Owner, $Repo)
    Get-Result $Request `
        | % {
            $Labels = $_.Labels | %{ $_.Name }
            $Eligible = ($Labels -contains $EligibleLabel)
            @{ Number = $_.Number; Title = $_.Title; Eligible = $Eligible }
        } `
        | ? { $_.Eligible } `
        | Sort-Object -Property Number
}

Write-Output "Pull requests eligible for merging:"
Get-EligiblePullRequests "chloekek" "norush-test" `
    | % { Write-Output "#$($_.Number): $($_.Title)" }
