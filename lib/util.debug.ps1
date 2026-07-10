# -*- coding: utf-8, tab-width: 2 -*-

function Debug-HeadAndTail {
  param([int]$Head, [int]$Tail, [string]$CmdName,
    [Parameter(ValueFromRemainingArguments)][string[]]$CmdArgs)
  Write-Host "Debug-HeadAndTail: $CmdName $CmdArgs"
  $output = & $CmdName $CmdArgs | & uniq.exe -c | & nl.exe -ba
  $output | & head.exe --lines=$Head
  $output | & tail.exe --lines=$Tail
}


function Describe-ObjectForDebugging($x) {
  Write-Host 'Describe-ObjectForDebugging:', $x
  $x | Get-Member -MemberType Property, Method | ForEach-Object {
    $k = $_.Name
    $t = $_.MemberType
    $d = "  • $t ${k}: $_"
    if ($t -eq 'Property') {
      try { $d += ' = ' + (Invoke-Expression "`$x.$k") } finally {}
    }
    Write-Host $d
  }
}





##
