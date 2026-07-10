# -*- coding: utf-8, tab-width: 2 -*-

if (!$env:SystemRoot) { return }

Add-Type -AssemblyName System.Windows.Forms


function Detect-SaveableImageFormats {
  # Force initialization of the Drawing subsystem:
  ([System.Drawing.Bitmap]::new(1, 1)).Dispose()

  # Now all encoders should have been loaded.
  $allEncoders = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders()
  $saveable = $allEncoders | ForEach-Object {
    [System.Drawing.Imaging.ImageFormat] |
      Get-Member -Static -MemberType Property |
      Where-Object { $_.Value -eq $_.FormatID } |
      Select-Object -ExpandProperty Name
  } | Sort-Object -Unique
  $saveable
}


function Convert-BoundsToLowercaseXYWH($b) {
  @{ x = $b.X; y = $b.Y; w = $b.Width; h = $b.Height; }
}


function Get-ScreensList {
  [System.Windows.Forms.Screen]::AllScreens | ForEach-Object { @{
    devName = $_.DeviceName -replace '^\\\\.*?\\', ''
    bounds = Convert-BoundsToLowercaseXYWH $_.Bounds
    workingArea = Convert-BoundsToLowercaseXYWH $_.WorkingArea
    isPrimary = $_.Primary
  } }
}


function Count-Screens { [System.Windows.Forms.Screen]::AllScreens.Count }


$Script:User32DllGetSystemMetrics = Import-SystemDllFunc user32.dll `
  int GetSystemMetrics 'int nIndex'


function Get-VirtualDesktopArea {
  @{
    x = (& $Script:User32DllGetSystemMetrics 76); # SM_XVIRTUALSCREEN
    y = (& $Script:User32DllGetSystemMetrics 77); # SM_YVIRTUALSCREEN
    w = (& $Script:User32DllGetSystemMetrics 78); # SM_CXVIRTUALSCREEN
    h = (& $Script:User32DllGetSystemMetrics 79); # SM_CYVIRTUALSCREEN
  }
}


function Wrap-NegativeCoordsInRect($Coords, $Rect, $sizeKeysMap) {
  # For when negative coordinates are defined as from the right/bottom.
  if (-not $sizeKeysMap) {
    $sizeKeysMap = @{ x='w'; y='h'; }
  }
  $Coords.Keys | ForEach-Object {
    $origKey = $_
    $origVal = $Coords[$origKey]
    if ($origVal -ge 0) { return $origVal }
    $sizeKey = $sizeKeysMap[$origKey]
    $sizeVal = $Rect[$sizeKey]
    return ($sizeVal + $origVal)
  }
}


function Get-MouseXY {
  $p = [System.Windows.Forms.Cursor]::Position
  @{ x = $p.X; y = $p.Y; }
}


function Set-MouseXY($x, $y) {
  $p = [System.Windows.Forms.Cursor]::Position
  if ($x -ne $null) { $p.X = $x }
  if ($y -ne $null) { $p.Y = $y }
  @{ x = $p.X; y = $p.Y; }
}







##
