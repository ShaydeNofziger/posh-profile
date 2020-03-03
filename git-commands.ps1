function repos {
    <#
    .SYNOPSIS
    Set location to git repos directory

    .DESCRIPTION
    Set location to git repos directory D:\Repos\

    .EXAMPLE
    repos

    .NOTES
    none
    #>
    Set-Location -Path 'D:\Repos\'
}

function repo {
    <#
    .SYNOPSIS
    Quickly go to a local git repo

    .DESCRIPTION
    Set location to a local git repo at D:\Repos\

    .EXAMPLE
    repo -RepoName posh-profile

    .NOTES
    If you give a RepoName that doesn't exist, it will error out. Use tab completionto be sure
    #>
    [CmdletBinding()]
    Param()

    DynamicParam {
        # Set the dynamic parameters' name
        $ParameterName = 'RepoName'

        # Create the dictionary
        $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

        # Create the collection of attributes
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]

        # Create and set the parameters' attributes
        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $true
        $ParameterAttribute.Position = 1

        # Add the attributes to the attributes collection
        $AttributeCollection.Add($ParameterAttribute)

        # Generate and set the ValidateSet
        $arrSet = (Get-ChildItem -Path 'D:\Repos\' -Directory).Name
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)

        # Add the ValidateSet to the attributes collection
        $AttributeCollection.Add($ValidateSetAttribute)

        # Create and return the dynamic parameter
        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterName, [string], $AttributeCollection)
        $RuntimeParameterDictionary.Add($ParameterName, $RuntimeParameter)
        return $RuntimeParameterDictionary
    }
    begin {
        # Bind the parameter to a friendly variable
        $RepoName = $PSBoundParameters[$ParameterName]
    }

    process {
        Set-Location -Path "D:\Repos\$RepoName"
    }
}

function profile {
    [CmdletBinding()]
    Param()

    code-insiders.cmd "$PSScriptRoot\profile.ps1"
}

function gs {
    [CmdletBinding()]
    Param()

    git status
}

function gp {
    [CmdletBinding()]
    Param()

    git pull
}

function gco {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [string]$BranchName
    )

    git checkout $BranchName
}

function gbd {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        $BranchName
    )

    git branch -D $BranchName
}

function gclean {
    [CmdletBinding()]
    Param()

    git fetch -p; git branch --verbose | Where-Object { $_.Contains('[gone]') } | ForEach-Object { git branch -D $_.TrimStart(' ').Split(' ')[0] --verbose }
}

function gitoops {
    <#
    .SYNOPSIS
    Undo previous commit(s).

    .DESCRIPTION
    Undoes previous commits locally on current branch.

    .PARAMETER NumberOfCommits
    Number of commits to undo. Defaults to 1.

    .EXAMPLE
    gitoops -NumberOfCommits 2

    .NOTES
    Must be on branch with commits to undo.
    #>
    [CmdletBinding()]
    Param(
        [Int]$NumberOfCommits = 1
    )

    git reset HEAD^$NumberOfCommits
}

function gitnuke {
    <#
    .SYNOPSIS
    Destroy all local changes not tracked in the remote branch

    .DESCRIPTION
    Destroy all local changes not tracked in the remote branch

    .PARAMETER BranchName
    Name of the branch to destroy and rebuild from remote

    .EXAMPLE
    gitnuke -BranchName master

    .NOTES
    Remote branch must exist
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [string]$BranchName
    )

    [string]$response = Read-Host -Prompt "WARNING: This command will blow away all un-pushed changes on the $BranchName branch and reset it to match the remote $BranchName branch. Are you sure you want to do this? 'YES' to continue."
    if ($response -notlike 'YES') {
        return
    }

    git checkout $BranchName
    git reset --hard origin/$BranchName
    git pull origin $BranchName
}