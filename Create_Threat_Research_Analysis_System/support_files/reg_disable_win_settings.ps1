# Unblock the installation script by running:
Unblock-File T:\workshopsCreate_Threat_Research_Analysis_Systemsupport_files\reg_disable_win_settings.ps1
# Enable script execution by running:
Set-ExecutionPolicy Unrestricted
# Disabele Windows Automatics Updates
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /t REG_DWORD /d 1

# Disable Windows Defender 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableBehaviorMonitoring /t REG_DWORD /d 1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableOnAccessProtection /t REG_DWORD /d 1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableScanOnRealtimeEnable /t REG_DWORD /d 1

#Disable OneDrive
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v DisableFileSyncNGSC /t REG_DWORD /d 1

#Prompt for reboot
$confirmation = Read-Host "Reboot System? [y/n]"
if ($confirmation -eq "y")
{
      Restart-Computer
}
elseif ($confirmation -eq 'n') 
    {
      exit
    }


# To verify if Win Defender is stopped run command "(Get-Service windefend).Status"
