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

cmdSilenceReturn(">nul 2>&1 REG delete ""HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"" /v ""NoWindowsUpdate"" /f")
cmdSilenceReturn(">nul 2>&1 sc config WaaSMedicSvc start=auto")
cmdSilenceReturn(">nul 2>&1 net start WaaSMedicSvc")
cmdSilenceReturn(">nul 2>&1 sc config wuauserv start=auto")
cmdSilenceReturn(">nul 2>&1 net start wuauserv")
FileDelete, % A_Startup "\BlockAutoUpdate.exe"

Exit, 0