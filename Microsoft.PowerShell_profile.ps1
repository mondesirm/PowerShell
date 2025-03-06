Import-Module PSReadLine
Import-Module Custom.Tools
Import-Folder Custom.Tools
Import-Folder Custom.Theme
Import-Module Microsoft.WinGet.CommandNotFound

Set-Alias pn pnpm
Set-PoshTheme bubbles

$env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path', 'User')

. (Join-Path -Path (Split-Path -Path $PROFILE -Parent) -ChildPath 'gh-copilot.ps1')