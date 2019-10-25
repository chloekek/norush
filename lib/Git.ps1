# The functions in this module operate on the Git repository in the working
# directory. The functions do not assume any particular branch being currently
# checked out, but they will do checkouts themselves and not restore these. The
# functions assume a remote called origin, and will keep this remote up-to-date
# with the local changes they make, and possibly vice versa.

# TODO: Gracefully handle Git commands failing. Do not leave the repository in
# a dirty state.

# TODO: If Git fails, report a PowerShell error.

function Git-Fetch {
    git fetch
}

function Git-Reset {
    param ([Parameter(Mandatory)] [string] $Branch)

    git checkout $Branch
    git reset --hard "origin/$Branch"
}

function Git-Rebase {
    param (
        [Parameter(Mandatory)] [string] $Base,
        [Parameter(Mandatory)] [string] $Head
    )

    git checkout $Head
    git rebase $Base
    git push --force-with-lease origin $Head
}

function Git-Merge {
    param (
        [Parameter(Mandatory)] [string] $Base,
        [Parameter(Mandatory)] [string] $Head
    )

    git checkout $Base
    git merge --no-edit --no-ff $Head
    git push origin $Base
}
