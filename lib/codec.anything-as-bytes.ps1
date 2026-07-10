# -*- coding: utf-8, tab-width: 2 -*-

function Convert-ToBytes($x) {
  if ($x -is [byte[]]) { return $x }
  if ($x -is [string]) { return [System.Text.Encoding]::UTF8.GetBytes($x) }
  throw [System.ArgumentException]'Unsupported data type.'
}








##
