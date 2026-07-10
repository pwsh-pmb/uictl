# -*- coding: utf-8, tab-width: 2 -*-

# seems redundant -> # Add-Type -AssemblyName System.Security.Cryptography


function Get-CryptoHash([string]$AlgoName, [object]$Data) {
  $bytes = Convert-ToBytes($Data)
  $hashAlgos = [System.Security.Cryptography.HashAlgorithm]
  $algoStateContainer = $hashAlgos::Create($AlgoName)
  if (-not $algoStateContainer) {
    $msg = "Unsupported crypto hash algorithm: '$AlgoName'"
    throw [System.ArgumentException]$msg
  }
  $hash = $null
  try {
    $hash = $algoStateContainer.ComputeHash($bytes)
  } finally {
    $algoStateContainer.Dispose()
  }
  return $hash # as byte[]. For hex or base64, see codec.bytes-as-text.ps1.
}


function Get-DrawingBitmapCryptoHash {
  param([string]$AlgoName, [System.Drawing.Bitmap]$Bitmap)
  $data = $Bitmap.LockBits(
    (New-Object System.Drawing.Rectangle(0, 0, $Bitmap.Width, $Bitmap.Height)),
    [System.Drawing.Imaging.ImageLockMode]::ReadOnly,
    [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $hash = ''
  try {
    $ptr = $data.Scan0
    $totalBytes = $data.Stride * $data.Height
    $pixelBytes = New-Object byte[] $totalBytes
    [System.Runtime.InteropServices.Marshal]::Copy($ptr,
      $pixelBytes, 0, $totalBytes)
    $hash = Get-CryptoHash -AlgoName $AlgoName -Data $pixelBytes
  } finally {
    $Bitmap.UnlockBits($data)
  }
  return $hash
}











##
