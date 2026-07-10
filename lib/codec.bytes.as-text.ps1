# -*- coding: utf-8, tab-width: 2 -*-

function Convert-BytesToUppercaseHexPairs([byte[]]$bytes) {
  return [System.BitConverter]::ToString($bytes).Replace('-', '')
}


function Convert-BytesToLowercaseHexPairs([byte[]]$bytes) {
  return Convert-BytesToUppercaseHexPairs($bytes).ToLower()
}


function Get-BytesAsText([byte[]]$Bytes, [string]$Format) {
  switch ($Format) {
    'all' {
      $hex = Convert-BytesToUppercaseHexPairs($Bytes)
      return @{
        base64 = [System.Convert]::ToBase64String($Bytes);
        bytes = $Bytes;
        hexLC = $hex.ToLower();
        hexUC = $hex;
      }
    }
    'base64' { return [System.Convert]::ToBase64String($Bytes) }
    'bytes' { return $Bytes }
    'hex' { return Convert-BytesToLowercaseHexPairs($Bytes) }
    'HEX' { return Convert-BytesToUppercaseHexPairs($Bytes) }
  }
  throw [System.ArgumentException]"Unsupported Format: '$Format'"
}










##
