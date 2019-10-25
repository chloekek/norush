function With-Location([string] $Directory, [ScriptBlock] $Action) {
    Push-Location $Directory
    try {
        Invoke-Command $Action
    } finally {
        Pop-Location
    }
}
