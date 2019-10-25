# Run an action in a directory. Move back to the previous directory when
# finished.
function With-Location {
    param (
        [Parameter(Mandatory)] [string] $Directory,
        [Parameter(Mandatory)] [ScriptBlock] $Action
    )

    Push-Location $Directory
    try {
        Invoke-Command $Action
    } finally {
        Pop-Location
    }
}
