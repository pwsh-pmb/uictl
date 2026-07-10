# -*- coding: utf-8, tab-width: 2 -*-

function Import-SystemDllFunc {
  param (
    [string]$FileName,  # e.g. 'user32.dll'
    [string]$FuncType,  # e.g. 'int'
    [string]$FuncName,  # e.g. 'SendMessage'
    [string]$FuncArgs,  # e.g. 'int hWnd, int Msg, int wParam, int lParam'
    [string]$Modifiers = 'public static',
    [string]$TypeName = '')  # usually the generated name is good enough.

  if ($FileName -match '[:/]') {
    $msg = 'Import-DllFunc is meant only for generic, system-global DLLs.'
    throw [System.ArgumentException]$msg
    # Otherwise we'd have to GetFullPath to reduce duplicates, but full paths
    # tend to have many fancy characters in them that we'd have to normalize
    # for the TypeName in a dupe-avoiding way. Too much hassle for a niche
    # use case. If your import is niche enough to need a path, you can
    # probably afford your own Add-Type.
  }

  if (-not $TypeName) {
    $TypeName = @(
      # Part 1: Trace hint: Where did this type come from?
      'Import_User32DllFunc',

      # Part 2: UUID avoids collisions with hopefully any other script.
      #   It has to be deterministic or we'll accumulate typedefs in memory!
      #   A hard-coded constant will do.
      '249af124-2b88-4b63-9868-d044a6e50160',

      # Part 3: Function signature.
      $FileName.ToLower(),
      $FuncType, $FuncName, $FuncArgs
      ) -join '|'
    # Now normalize the characters for a valid type name:
    $TypeName = $TypeName -replace '\*', 'AST'
    $TypeName = $TypeName -replace '\[\]', 'ARR'
    $TypeName = $TypeName -replace '[^A-Za-z0-9]+', '_'
    # ^-- No '_' in char group: Make 'char[] __foo' become just 'charARR_foo'.
  }

  $typeRef = [Type]::GetType($TypeName)
  if (-not $typeRef) {
    $def = ('[DllImport("' + $FileName + '", SetLastError=true)] extern ' `
      + "$Modifiers $FuncType $FuncName ($FuncArgs);")
    $typeRef = Add-Type -MemberDefinition $def -Name $TypeName `
      -PassThru -ErrorAction Stop
  }

  $method = $typeRef.GetMethod($FuncName)
  $callback = {
    $method.Invoke($null, (Convert-ArgsForMethod $method $args))
  }.GetNewClosure()
  return $callback
}


function Get-LastDllFuncErrorCode {
  [uint32]([System.Runtime.InteropServices.Marshal]::GetLastWin32Error())
}


function Get-WindowsErrorDetails([uint32]$ErrNum) {
  $msg = ''
  try {
    $exc = [System.ComponentModel.Win32Exception][int]$ErrNum
    # ^-- 2026-07-21: Verified: This double cast works in PS 5.1.
    $msg = $exc.Message
    # Trying to find the name (like ERROR_INVALID_PARAMETER) from reflection
    # is useless because that mapping is private to the DLL, unfortunately.
    # $fields = [System.ComponentModel.Win32Exception].GetFields(
    #     [System.Reflection.BindingFlags]::Public -bor
    #     [System.Reflection.BindingFlags]::Static
    # ) | Where-Object { $_.FieldType -eq [uint32] }
    # $fields = $fields | Where-Object { $_.GetValue($null) -eq $ErrNum }
    # if ($fields.Length -eq 1) { $name = $fields[0].Name }
  } catch {}
  if (!$Name) { $Name = '' }
  return @{ code = $ErrNum; msg = $msg; }
}


function Throw-OnLastDllFuncErrorCode([dict]$ExpectedErrors) {
  $errNum = Get-LastDllFuncErrorCode
  $errMsg = $ExpectedErrors[$errNum]
  # :TODO: Implement
}












##
