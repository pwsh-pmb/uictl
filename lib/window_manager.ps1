# -*- coding: utf-8, tab-width: 2 -*-

Add-Type -AssemblyName Microsoft.VisualBasic


function Activate-WindowByPartialTitle($WinTitlePart, $HowOften = 2) {
  # $HowOften: Sometimes the first activation has no visible effect,
  # but the second attempt seems reliable.
  while ($HowOften -ge 1) {
    [Microsoft.VisualBasic.Interaction]::AppActivate($WinTitlePart)
    Start-Sleep -Seconds 0.1
    $HowOften -= 1
  }
}










##
