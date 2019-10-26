# The functions in this module operate on the Git repository in the working
# directory. The functions do not assume any particular branch being currently
# checked out, but they will do checkouts themselves and not restore these. The
# functions assume a remote called origin, and will keep this remote up-to-date
# with the local changes they make, and possibly vice versa.

function Git-Fetch {
    git fetch
    if (!$?) {
        Throw "git fetch"
    }
}

function Git-Reset {
    param ([Parameter(Mandatory)] [string] $Branch)

    git checkout $Branch
    if (!$?) {
        Throw "git checkout"
    }

    git reset --hard "origin/$Branch"
    if (!$?) {
        Throw "git reset"
    }
}

function Git-Rebase {
    param (
        [Parameter(Mandatory)] [string] $Base,
        [Parameter(Mandatory)] [string] $Head
    )

    git checkout $Head
    if (!$?) {
        Throw "git checkout"
    }

    git rebase $Base
    if (!$?) {
        git rebase --abort
        Throw "git rebase"
    }

    git push --force-with-lease origin $Head
    if (!$?) {
        Throw "git push"
    }
}

function Git-Merge {
    param (
        [Parameter(Mandatory)] [string] $Base,
        [Parameter(Mandatory)] [string] $Head
    )

    git checkout $Base
    if (!$?) {
        Throw "git checkout"
    }

    git merge --no-edit --no-ff $Head
    if (!$?) {
        git merge --abort
        Throw "git merge"
    }

    git push origin $Base
    if (!$?) {
        Throw "git push"
    }
}
