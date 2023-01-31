:: Unblock Disable Defender Script and Window Setup Script
cmd /C powershell.exe Unblock-File T:\workshopsCreate_Threat_Research_Analysis_Systemsupport_files\disable-defender.ps1
cmd /C powershell.exe Unblock-File T:\workshopsCreate_Threat_Research_Analysis_Systemsupport_files\windows-setup-runonce.ps1
cmd /C powershell.exe Set-ExecutionPolicy Unrestricted -force

:: Run Disable Defender Script and Window Setup Script
cmd /C powershell.exe -ExecutionPolicy Bypass -File T:\workshopsCreate_Threat_Research_Analysis_Systemsupport_files\disable-defender.ps1
cmd /C powershell.exe -ExecutionPolicy Bypass -File T:\workshopsCreate_Threat_Research_Analysis_Systemsupport_files\windows-setup-runonce.ps1

:: Restart Computer via PowerShell
cmd /C powershell.exe Restart-Computer
