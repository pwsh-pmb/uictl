# -*- coding: utf-8, tab-width: 2 -*-

if (!$env:SystemRoot) { return }

Add-Type -AssemblyName System.Windows.Forms


function Find-VirtualKeyNumber($vkName) {
  if (!$vkName) { throw [System.ArgumentException]'No key name given!' }
  $found = [System.Windows.Forms.Keys]::$vkName # Enum supports string lookup.
  if ($found) { return [byte]$found }
  throw [System.ArgumentException]"Unknown key name: '$vkName'"
}


$Script:User32DllKeybdEvent = Import-SystemDllFunc user32.dll `
  void keybd_event 'uint bVk, uint bScan, int dwFlags, int dwExtraInfo'


function Send-SingleBasicKeyboardEvent($Key, $Flags) {
  if ($Key -is [string]) { $Key = Find-VirtualKeyNumber $Key }
  & $Script:User32DllKeybdEvent $Key 0 $Flags 0
}


function Send-SingleKeyDownEvent($Key) {
  Send-SingleBasicKeyboardEvent $Key 0
}


function Send-SingleKeyUpEvent($Key) {
  Send-SingleBasicKeyboardEvent $Key 2
}


function Send-Keys($spec) {
  # ATTN: SendKeys keynames diverge from the [….Keys] enum!
  [System.Windows.Forms.SendKeys]::SendWait($spec)
}


# Send-SingleKeyDownEvent LShiftKey
# Send-SingleKeyDownEvent x
# Send-SingleKeyUpEvent x
# Send-SingleKeyDownEvent y
# Send-SingleKeyUpEvent y
# Send-SingleKeyUpEvent LShiftKey











##
