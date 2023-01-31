# Unblock the installation script by running:
cmd /C powershell.exe Unblock-File T:\support_files\reg_disable_win_settings.ps1
# Enable script execution by running:
cmd /C powershell.exe  Set-ExecutionPolicy Unrestricted -force
cmd /C powershell.exe  T:\support_files\reg_disable_win_settings.ps1
