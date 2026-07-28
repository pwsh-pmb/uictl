# -*- coding: utf-8, tab-width: 2 -*-


function Join-AsStrings([string]$Glue=', ') {
  ($input | ForEach-Object { [string]$_ }) -join $Glue
}


function ForEach-ObjectAsJson {
  $input | ForEach-Object { $_ | ConvertTo-Json -Compress }
}


function Get-CartesianProduct($sets) {
  $n = $sets.Length
  if ($n -lt 1) { return @() }
  $a = $sets[0]
  if ($n -eq 1) { return $a }
  $b = $sets[1]
  if ($n -ge 3) { $b = Get-CartesianProduct @($sets[1..($n-1)]) }
  foreach ($x in $a) { foreach ($y in $b) { ,@($x; $y) } }
}


function Get-ReverseCartesianProduct($sets) {
  $n = $sets.Length
  if ($n -lt 1) { return @() }
  $a = $sets[0]
  if ($n -eq 1) { return $a }
  if ($n -ge 3) { $a = Get-ReverseCartesianProduct @($sets[0..($n-2)]) }
  $b = $sets[$n-1]
  foreach ($y in $b) { foreach ($x in $a) { ,@($x; $y) } }
}


function Demonstrate-CartesianProductAndReverse {
  'RGB:'
  Get-CartesianProduct @('r', 'R'), @('g', 'G'), @('b', 'B') |
    ForEach-ObjectAsJson
  'BGR:'
  Get-ReverseCartesianProduct @('r', 'R'), @('g', 'G'), @('b', 'B') |
    ForEach-ObjectAsJson
}


# Demonstrate-CartesianProductAndReverse















##
