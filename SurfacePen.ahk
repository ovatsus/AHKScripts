#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; 1: A window's title must start with the specified WinTitle to be a match.
; 2: A window's title can contain WinTitle anywhere inside it to be a match.
; 3: A window's title must exactly match WinTitle to be a match.
SetTitleMatchMode 2

; #F20 - Pen click
; #F19 - Pen double click
; #F18 - Pen long press

;========== Powerpoint in presentation mode ==========

#IfWinActive ahk_class screenClass
  #F20::
    Send {PgDn}
    return
  #F19::
    Send {PgUp}
    return
#IfWinActive

;========== VLC ==========

#IfWinExist, ahk_exe vlc.exe
  #F20::
    ControlSend, ahk_parent, {Space}
    return
  #F19::
    ControlSend, ahk_parent, {Left}
    return
#IfWinActive

;========== Groove ==========

#IfWinExist, Groove Music
  #F19::
    Send {Media_Prev}
    return
#IfWinActive

;========== Global ==========

#F20::Media_Play_Pause
#F18::AltTabMenu

;========== Chrome ==========

#IfWinActive, ahk_exe chrome.exe
 #F19::
    Gosub Rewind
    return
#IfWinActive

#IfWinNotActive, ahk_exe chrome.exe
  #F19::
    ControlGet, controlID, Hwnd,,Chrome_RenderWidgetHostHWND1, Google Chrome
    ControlFocus,,ahk_id %controlID%
    Gosub Rewind
    return
#IfWinNotActive

Rewind:

  RewindSiteToKeyMappings := { "YouTube": "j", "Udemy": "{Left}", "Vimeo": "{Left}", "Patreon": "{Left}", "Jazzedge": "{Left}", "HomeSchoolPiano": "{Left}", "Learn Piano Blues": "{Left}", "Summer Piano Jam": "{Left}", "Jazz Christmas Music": "{Left}" }

  tabCount := 0
  Loop {
    found := false
    for tabTitle, key in RewindSiteToKeyMappings {
      IfWinExist %tabTitle%
      {
        found := true
        break
      }
    }
    if found {
      break
    }
    ControlSend, , ^{PgUp} , Google Chrome
    tabCount := tabCount + 1
    Sleep 150
    if (tabCount = 10) {
      break
    }
  }
  if (tabCount < 10) {
    ControlSend, , %key% , Google Chrome
  }
  Loop, %tabCount% {
    ControlSend, , ^{PgDn} , Google Chrome
    Sleep 150
  }
  return

