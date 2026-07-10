# -*- coding: utf-8, tab-width: 2 -*-

function Get-FirstNonNullValue {
  foreach ($a in $args) { if ($a -ne $null) { return $a } }
}


function Export-FunctionsToScope {
  param (
    # -FromSource: Filename used when they were dot-sourced
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path $_ })]
    [string]$FromSource,

    # -DestScope: Where you want the functions.
    [ValidateSet('Script','Global')][string]$DestScope='Script'
  )
  $slashyFromSource = $FromSource.Replace('\', '/').TrimEnd('/') + '/'
  $input | ForEach-Object {
    $funcInfo = $_
    if ($funcInfo -isnot [System.Management.Automation.FunctionInfo]) { return }
    if ($funcInfo.CommandType -ne 'Function') { return }
    $funcImpl = $funcInfo.ScriptBlock
    if (-not $funcImpl) { return }
    $funcFrom = $funcImpl.File
    if (-not $funcFrom) { return }
    $funcFrom = $funcFrom.Replace('\', '/').TrimEnd('/') + '/'
    $accept = ($funcFrom -eq $FromSource)
    if (!$accept) {
      $slashyFuncFrom = $funcFrom.Replace('\', '/').TrimEnd('/') + '/'
      $accept = $slashyFuncFrom.StartsWith($slashyFromSource)
    }
    if (!$accept) { return }
    $DestPath = "$($funcInfo.CommandType):${DestScope}:$($funcInfo.Name)"
    Set-Item -Path $DestPath -Value $funcImpl
  }
}













##
