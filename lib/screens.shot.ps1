# -*- coding: utf-8, tab-width: 2 -*-

if (!$env:SystemRoot) { return }

Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms


function Take-Screenshot {
  param([int]$s,  # screen number, 0-based
    [int]$x = 0,  # left ignored margin; negative = from right
    [int]$y = 0,  # top ignored margin; negative = from bottom
    [int]$w = 0,  # positive = width, 0 or negative = right ignored margin
    [int]$h = 0,  # positive = height, 0 or negative = bottom ignored margin
    [double]$m = 1.0, # magnification/ zoom/ scale
    [int]$maxW, [int]$maxH, # if positive, impose limit on $m.
    # [string]$pxfmt = 'System.Drawing.Bitmap',
    [int]$maxL = 0) # outputLineLengthLimit for Write-StreamAsBase64
  $bounds = [System.Windows.Forms.Screen]::AllScreens[$s].Bounds
  if ($x -lt 0) { $x += $bounds.Width }
  if ($y -lt 0) { $y += $bounds.Height }
  if ($w -le 0) { $w += $bounds.Width - $x } # :TODO: Is -x correct here?
  if ($h -le 0) { $h += $bounds.Height - $y } # :TODO: Is -y correct here?
  if ($m -le 0) { $m = 1 }

  # Accumulation of rounding errors probably won't matter too much for
  # realistic screen resolutions.
  if ($maxW -ge 1) { $m = [Math]::Min($m, $maxW / $w); }
  if ($maxH -ge 1) { $m = [Math]::Min($m, $maxH / $h); }
  $outW = [int][Math]::Floor($w * $m)
  $outH = [int][Math]::Floor($h * $m)

  # Float math sometimes has curious edge cases, so let's be double sure
  # about the output size limits.
  if (($maxW -ge 1) -and ($outW -gt $maxW)) { $outW = $maxW }
  if (($maxH -ge 1) -and ($outH -gt $maxH)) { $outH = $maxH }

  # Pre-declare buffers so we can use a single try…finally block for cleanup:
  $bitmap = $null
  $graphics = $null
  $memStream = $null
  $rescaled = $null

  try {
    $bitmap = New-Object System.Drawing.Bitmap($w, $h)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.CopyFromScreen(
      [System.Drawing.Point]::new($x, $y),
      [System.Drawing.Point]::Empty,
      [System.Drawing.Size]::new($w, $h))
    $graphics.Dispose()

    if ($m -ne 1) {
      $rescaled = New-Object System.Drawing.Bitmap($outW, $outH)
      $graphics = [System.Drawing.Graphics]::FromImage($rescaled)
      $scaleModes = [System.Drawing.Drawing2D.InterpolationMode]
      $graphics.InterpolationMode = $scaleModes::HighQualityBicubic
      $graphics.DrawImage($bitmap,
        [System.Drawing.RectangleF]::new(0, 0, $outW, $outH),
        [System.Drawing.RectangleF]::new(0, 0, $w, $h),
        [System.Drawing.GraphicsUnit]::Pixel)
      $graphics.Dispose()
      $bitmap.Dispose()
      $bitmap = $rescaled
      $rescaled = $null # The .Dispose() will later be invoked via $bitmap.
    }

    $memStream = New-Object System.IO.MemoryStream
    $bitmap.Save($memStream, [System.Drawing.Imaging.ImageFormat]::Png)
    $bitmap.Dispose()
    $memStream.Flush()
    $memStream.Position = 0
    Write-Output "## BEGIN screenshot ## $w x $h -> $outW x $outH"
    Write-StreamAsBase64 $memStream $maxL
    Write-Output '## ENDOF screenshot ##'
    $memStream.Dispose()
  } finally {
    # 2026-06-29: Verified: Safe to repeat .Dispose() on the same object.
    if ($bitmap)   { $bitmap.Dispose() }
    if ($graphics) { $graphics.Dispose() }
    if ($memStream)   { $memStream.Dispose() }
    if ($rescaled) { $rescaled.Dispose() }
  }
}

# Example: Capture the taskbar clock:
# Take-Screenshot -maxL 200 -x (-100) -y (-50) -w 100 -h 50 -z 0.5










##
