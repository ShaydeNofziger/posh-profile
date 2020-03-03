function ~ {
    Set-Location -Path "~"
}

function desktop {
    Set-Location -Path "~\Desktop"
}

function documents {
    Set-Location -Path "~\Documents"
}

New-Alias -Name 'docs' -Value 'documents'

function scratch {
    code-insiders.cmd 'D:\Repos\scratch'
}
