# -*- coding: utf-8, tab-width: 2 -*-

function Check-IsEntrypoint {
  param(
    [Parameter(Mandatory = $true)]
    [System.Management.Automation.CallStackFrame[]]$CallStack
  )
  # Write-Host 'Debug: $CallStack size is', $CallStack.Count
  if ($CallStack.Count -ge 2) { return $false }
  $frame = $CallStack[0]
  # Describe-ObjectForDebugging $frame
  if (-not $frame.ScriptName) { return $false }
  $ignCase = [System.StringComparison]::OrdinalIgnoreCase
  if (-not $frame.ScriptName.EndsWith('.ps1', $ignCase)) { return $false }
  if ($frame.FunctionName -notlike '<Script*>') { return $false }
  return $true
}

if (Check-IsEntrypoint (Get-PSCallStack)) {
  $ErrorActionPreference = 'Stop'
  Set-StrictMode -Version 3
  $err = New-Object System.Management.Automation.ErrorRecord(
    [System.InvalidOperationException]::new('Check-IsEntrypoint' +
      " seems broken, or you ran it directly, which you shouldn't." +
      " It's meant to be dot-sourced."),
    "ScriptIsMeantToBeDotSourced",
    [System.Management.Automation.ErrorCategory]::InvalidOperation,
    $null)
  throw $err
}






##
