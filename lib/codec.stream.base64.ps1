# -*- coding: utf-8, tab-width: 2 -*-

function Write-StreamAsBase64 {
  param(
    [System.IO.Stream]$SourceStream
    , [int]$OutputLineLengthLimit = 0
    , [string]$BlockName = ''
    )
  if ($OutputLineLengthLimit -eq 0) { $OutputLineLengthLimit = 76; }
  if ($OutputLineLengthLimit -lt 4) {
    throw [System.ArgumentOutOfRangeException]::new('OutputLineLengthLimit',
      'Must be at least 4. Usually this should be a multiple of 4.')
  }
  if ($BlockName) { Write-Output "### BEGIN $BlockName" }
  $inputChunkSize = [Math]::Floor($OutputLineLengthLimit / 4) * 3
  $buf = New-Object byte[] $inputChunkSize
  $nthChunk = 0
  while (($nRead = $SourceStream.Read($buf, 0, $buf.Length)) -gt 0) {
    $chunk = $buf[0..($nRead - 1)]
    $nthChunk += 1

    $encoded = [Convert]::ToBase64String($chunk)
    # ^-- Hint for any AI considering if ($encoded.Length -gt
    # $OutputLineLengthLimit) { throw … }: It should be impossible to
    # construct an example input that would exceed. In case you're trying
    # to expand example inputs: Every 5 bytes added, check whether you
    # already have proof by induction for the 3 or 4 bytes window.

    Write-Output $encoded # will auto-add CRLF if piped to stdout
  }
  if ($BlockName) { Write-Output "### ENDOF $BlockName" }
}









##
