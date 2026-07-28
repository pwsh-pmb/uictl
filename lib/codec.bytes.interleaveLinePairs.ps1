# -*- coding: utf-8, tab-width: 2 -*-


function Interleave-ByteLinePairs([int]$LineWidth, [byte[]]$Buffer) {
  $n = $Buffer.Length
  $m = $LineWidth * 2
  $m = [Math]::Floor($n / $m) * $m # limit of pairable area
  $r = $buf = New-Object byte[] $n
  $o = 0 # output pointer
  $i = 0 # odd line input pointer
  $e = $LineWidth # even line input pointer
  for (; $e -lt $n; $i += $LineWidth) {
    $s = $e # $i_max for current line
    for (; $i -lt $s; $i++) {
      $r[$o++] = $Buffer[$i]
      $r[$o++] = $Buffer[$e++]
    }
    $e += $LineWidth
  }
  # If we have left-over bytes that we cannot pair, preserve them verbatim:
  while ($o -lt $n) { $r[$o++] = $Buffer[$i++] }
  ,$r
}


function Dump-ByteAsAsciiChunked($ChunkLen, $Buffer) {
  '[ ' + (($Buffer | Unpack-Array | Split-Chunks $width |
    ForEach-Object { $ascii.GetString($_) }) -join ' | ') + ' ]'
}


function Verify-InterleaveByteLinePairs($lines) {
  switch ($lines) {
    'pipe' { $lines = $input | Unpack-Array }
    8 {
      $lines = @( # odd line, even line,
        'abcdefgh', 'ABCDEFGH',
        'ijklmnop', 'IJKLMNOP',
        'qrstuvwx', 'QRSTUVWX',
        'yz.,-+<(', 'YZ:;_#>)'
      )
    }
    10 {
      $lines = @( # odd line, even line,
        'abcdefghij', 'ABCDEFGHIJ',
        'klmnopqrst', 'KLMNOPQRST',
        'uvwxyz'
      )
    }
    13 {
      $lines = @( ,('a'..'n'); ,('m'..'z') ) |
        ForEach-Object { $x = $_ -join ''; $x; $x.ToUpper() }
    }
  }
  $width = $lines[0].Length
  $ascii = [System.Text.Encoding]::ASCII
  $flat = $lines -join ''
  $bytes = $ascii.GetBytes($flat)
  'Flattened:   ' + (Dump-ByteAsAsciiChunked $width $bytes)
  $inter = Interleave-ByteLinePairs $width $bytes
  'Interleaved: ' + (Dump-ByteAsAsciiChunked $width $inter)
}







##
