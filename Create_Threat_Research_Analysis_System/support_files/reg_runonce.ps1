Write-Host "Changing RunOnce script." -foregroundcolor "magenta"
$RunOnceKey = "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
set-itemproperty $RunOnceKey "NextRun" ('C:\Windows\System32\WindowsPowerShell\v1.0\Powershell.exe -executionPolicy Unrestricted -File ' + "T:\workshops\Create_Threat_Research_Analysis_System\support_files\Windows_install_tools.ps1")
