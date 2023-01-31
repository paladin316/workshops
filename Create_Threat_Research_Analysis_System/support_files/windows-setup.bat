:: Unblock Disable Defender Script and Window Setup Script
cmd /C powershell.exe Unblock-File T:\support_files\disable-defender.ps1
cmd /C powershell.exe Unblock-File T:\support_files\windows-setup-runonce.ps1
cmd /C powershell.exe Set-ExecutionPolicy Unrestricted -force

:: Run Disable Defender Script and Window Setup Script
cmd /C powershell.exe -ExecutionPolicy Bypass -File T:\support_files\disable-defender.ps1
cmd /C powershell.exe -ExecutionPolicy Bypass -File T:\support_files\windows-setup-runonce.ps1

:: Restart Computer via PowerShell
cmd /C powershell.exe Restart-Computer
