# -*- coding: utf-8, tab-width: 2 -*-

function Get-VT100BasicColorDefaults {
  $c = foreach ($intensity in @(128, 255)) {
    Get-ReverseCartesianProduct @( ,@([byte]0, [byte]$intensity) * 3 )
  }
  $c[8] = $c[7] # move bright black into position
  $c[7] = @([byte]192) * 3 # dim white is a special snowflake
  ,[byte[][]]$c
  # ^-- Without the comma, the outer array would be re-packaged
  #     and become a System.Object of [byte[]].
}


function Verify-VT100BasicColorDefaults {
  & {
    $c = Get-VT100BasicColorDefaults
    $c | ForEach-ObjectAsJson | & nl -v0
    $c -is [byte[][]]
    $c[0].GetType().FullName
    $c[0][0].GetType().FullName
  } | & sed -re 's~^ *~# ~'
}


function Get-Xterm256ColorPalette([switch]$Blackout16) {
  ,[byte[][]]@(
    if ($Blackout16) {
      # Black-out colors affected by user color scheme.
      # Palette reduction will probably use the first matching entry,
      # so whatever color we choose for the first 16 slots, there will
      # always be one color in the original colorspace that mistakenly
      # maps to entry 0. We choose black for simplicity, so you'll have
      # to manually palette-swap 0 -> 16.
      @( @(0) * 3) * 16
    } else {
      Get-VT100BasicColorDefaults
    }
    Get-CartesianProduct @( ,@(0, 95, 135, 175, 215, 255) * 3 )
    foreach ($grey in 0..23) { ,@( (($_ * 10) + 8) ) * 3 }
  )
}








##
