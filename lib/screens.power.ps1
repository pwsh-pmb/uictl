# -*- coding: utf-8, tab-width: 2 -*-

function Suspend-Screen {
  param ([int]$Repeats = 0, [int]$IntvSec = 60)
  while ($true) {
    $null = Broadcast-User32WindowMessage 0x0112 0xF170 2
    if ($Repeats -lt 1) { break }
    $Repeats -= 1
    Start-Sleep -Seconds $IntvSec
  }
}







##
