Import-Module Custom.Tools
Import-Folder Custom.Tools
Import-Folder Custom.Theme
Import-Module Microsoft.WinGet.CommandNotFound

Set-Alias pn pnpm
Set-PoshTheme bubbles

function art { php artisan $args }
function tinker { art tinker $args }
function pest { ./vendor/bin/pest $args }
function pint { ./vendor/bin/pint $args }

function port { netstat -ano | sls 'tcp' | sls 'listening' | sls $args[0] }
function pkill { port $args | % { Stop-Process -Id $_.ToString().Split()[-1] } }

$env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path', 'User')

. (Join-Path -Path (Split-Path -Path $PROFILE -Parent) -ChildPath 'gh-copilot.ps1')