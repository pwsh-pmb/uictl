# -*- coding: utf-8, tab-width: 2 -*-


function Join-AsStrings([string]$Glue=', ') {
  ($input | ForEach-Object { [string]$_ }) -join $Glue
}















##
