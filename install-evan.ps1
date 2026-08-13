# Installs (or updates) evan.sty into the user texmf tree, so that ANY .tex file
# on this machine can `\usepackage{evan}` without a local copy of the file.
#
#   powershell -ExecutionPolicy Bypass -File install-evan.ps1
#
# Re-run it any time to pull the latest evan.sty from upstream.

$ErrorActionPreference = 'Stop'

$Source = 'https://raw.githubusercontent.com/vEnhance/dotfiles/main/texmf/tex/latex/evan/evan.sty'
$Root   = Join-Path $env:USERPROFILE 'texmf'
$Dest   = Join-Path $Root 'tex\latex\evan'

New-Item -ItemType Directory -Force -Path $Dest | Out-Null

Write-Host "Downloading evan.sty ..."
Invoke-WebRequest -Uri $Source -OutFile (Join-Path $Dest 'evan.sty')

# Register the tree with MiKTeX (harmless to repeat) and rebuild the file index.
# MiKTeX will not find anything under $Root until the fndb is refreshed.
Write-Host "Registering $Root and refreshing the filename database ..."
& initexmf --register-root="$Root"
& initexmf --update-fndb

Write-Host ""
Write-Host "evan.sty resolves to:" -NoNewline
Push-Location $env:TEMP          # step outside any folder holding a local copy
& kpsewhich evan.sty
Pop-Location
