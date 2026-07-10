# -*- coding: utf-8, tab-width: 2 -*-


function Round-AwayFromZero($Number) {
  # .NET by default prefers "round to even", because it's the default for
  # IEEE 754 floats, because it minimizes bias in statistical computations.
  # ([Math]::Round(1.5) -eq 2) -and ([Math]::Round(0.5) -eq 0) # 🤦‍♂️🧮🤦‍♀️
  # If we want regular rounding, we need this lengthy incantation:
  [Math]::Round($Number, 0, [MidpointRounding]::AwayFromZero)
}


function Make-IncreasingIntegersEnforcer {
  param ([int]$Min=[int]::MinValue, [int]$Max=[int]::MaxValue)
  if ($Min -gt $Max) { throw [System.ArgumentException]"Min=$min > $max=Max" }
  $state = @{ nHad=0; prev=$null; }
  $checkRange = {
    param ($val)
    if ($val -lt $Min) { return 'is below minimum'; }
    if ($val -gt $Max) { return 'is above maximum'; }
    if ($state.prev -eq $null) { return }
    if ($val -le $state.prev) { return 'must be greater than previous value'; }
  }.GetNewClosure()
  $enforceRange = {
    param ($val)
    $bad = & $checkRange $val
    if ($bad) {
      $msg = "After $($state.nHad) acceptable values: Value $val $bad!"
      throw [System.ArgumentException]$msg
    }
    $state.nHad += 1
    # Write-Host "Adding #$($state.nHad) $val > $($state.prev)"
    $state.prev = $val
    return $val
  }.GetNewClosure()
  return $enforceRange
}








##
