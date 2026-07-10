# -*- coding: utf-8, tab-width: 2 -*-

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 3
$Script:uictlLibsDir = $PSScriptRoot
# Write-Host "Running on PowerShell v$($PSVersionTable.PSVersion)"


function Source-AllREPLModules {
  Get-ChildItem -Path $Script:uictlLibsDir -Filter '*.ps1' |
  Sort-Object Name | ForEach-Object {
    $name = $_.Name
    if ($name.StartsWith('__')) { return }
    if ($name.StartsWith('tmp.')) { return }
    if (-not ($name -match '^[A-Za-z0-9_]')) { return }
    # Write-Host "Load uictl lib:", $_.FullName
    try {
      . $_.FullName
    } catch {
      $msg = "Failed to dot-source sibling file '$name': $_   --- @ $name"
      Write-Warning $msg
    }
  }
  Get-Command -Name '*' |
    Export-FunctionsToScope -FromSource $Script:uictlLibsDir
}


Source-AllREPLModules

if ($args.Length -and $args[0]) {
  foreach ($a in $args) { Invoke-Expression $a }
} else {
  Start-REPL -Prompt "(repl_ready)`n" -ExitMsg '(repl_quit)'
}
