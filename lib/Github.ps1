# Load the Octokit library as produced by nix/octokit.nix. The environment
# variable is supplied by the wrapper generated in default.nix.
Add-Type -Path "$env:OCTOKIT/lib/Octokit.dll"

# Create a GitHub client with the given configuration.
function Open-GithubClient([string] $OauthToken) {
    $UserAgent = [Octokit.ProductHeaderValue]::new("norush")
    $GitHub = [Octokit.GitHubClient]::new($UserAgent)

    $Credentials = [Octokit.Credentials]::new($OauthToken)
    $GitHub.Credentials = $Credentials

    $Github
}
