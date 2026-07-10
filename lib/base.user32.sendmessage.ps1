# -*- coding: utf-8, tab-width: 2 -*-

$Script:User32DllSendMessage = Import-SystemDllFunc user32.dll `
  int SendMessage 'IntPtr hWnd, int Msg, int wParam, int lParam'


function Send-User32WindowMessage {
  param ([IntPtr]$hWnd, [int]$Msg, [int]$wParam, [int]$lParam)
  & $Script:User32DllSendMessage $hWnd $Msg $wParam $lParam
}


function Broadcast-User32WindowMessage {
  param ([int]$Msg, [int]$wParam, [int]$lParam)
  & $Script:User32DllSendMessage ([IntPtr]-1) $Msg $wParam $lParam
}









##
