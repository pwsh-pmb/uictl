# -*- coding: utf-8, tab-width: 2 -*-

function Unwrap-PSObject($x) {
  $x | ForEach-Object { $_.psobject.BaseObject }
}


function Convert-ToTypeByTypeInfo([Type]$DestType, [object]$OrigValue) {
  try {
    if ($null -eq $OrigValue) {
      if ($DestType.IsValueType -and $DestType.IsEnum) {
        return [Activator]::CreateInstance($DestType)
      }
      return $null
    }
    return [Convert]::ChangeType($OrigValue, $DestType)
  } catch {
    $e = New-Object System.Management.Automation.ErrorRecord(
      $_.Exception, 'PInvokeArgumentConversionFailed',
      [System.Management.Automation.ErrorCategory]::InvalidArgument,
      $OrigValue)
    $d = $e.Exception.Data
    $d['OrigType'] = if ($OrigValue -eq $null) { '$null' } else {
      $OrigValue.GetType().FullName }
    $d['OrigValue'] = $OrigValue
    $d['DestType'] = $DestType.FullName
    throw $e
  }
}


function Convert-ArgsForMethod {
  param ([Reflection.MethodInfo]$Method, [object[]]$OrigArgs)
  if (-not $Method) { throw [System.ArgumentException]'No method given!' }
  $p = $Method.GetParameters()
  $n = $p.Length
  $c = New-Object 'object[]' $n
  for ($i = 0; $i -lt $n; $i += 1) {
    $v = $OrigArgs[$i]
    $t = $p[$i].ParameterType
    try {
      $c[$i] = Convert-ToTypeByTypeInfo $t $v
    } catch {
      $details = $_.Exception.Data
      $details['ParameterIndex'] = $i
      $details['ParameterName'] = $p[$i].Name
      throw $_
    }
  }
  return $c
}


# $method = [System.String].GetMethod('Substring',
#   [System.Reflection.BindingFlags]::Public -bor
#   [System.Reflection.BindingFlags]::Instance,
#   $null, @([Int32], [Int32]), $null)
# Convert-ArgsForMethod $method @('5', '1')










##
