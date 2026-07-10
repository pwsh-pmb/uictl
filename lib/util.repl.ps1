# -*- coding: utf-8, tab-width: 2 -*-

function Start-REPL {
  param ([string]$Prompt = '', [string]$ExitMsg = '')
  while ($true) {
    try {
      if ($Prompt) { Write-Host -NoNewLine $Prompt }
      # No parameters for Read-Host, because it would append ': '.
      $cmd = Read-Host
      $cmd = ([string]$cmd).Trim()
      if ($cmd -eq 'exit') { break }
      if (!$cmd) { continue }
      Invoke-Expression $cmd
    } catch {
      # We cannot Write-Error because that would trigger the error action stop
      Write-Warning "$_"
    }
  }
  if ($ExitMsg) { Write-Host $ExitMsg }
}


##
