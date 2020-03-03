function ~ {
    Set-Location -Path "~"
}

function desktop {
    Set-Location -Path "~\Desktop"
}

function documents {
    Set-Location -Path "~\Documents"
}

function scratch {
    code-insiders.cmd 'D:\Repos\scratch'
}
