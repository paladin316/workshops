#Install AtomicRedTeam
echo "Installing AtomicRedTeam"
IEX (IWR 'https://raw.githubusercontent.com/redcanaryco/invoke-atomicredteam/master/install-atomicredteam.ps1' -UseBasicParsing);
Install-AtomicRedTeam -getAtomics
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Import-Module "C:\AtomicRedTeam\invoke-atomicredteam\Invoke-AtomicRedTeam.psd1" -Force
echo "AtomicRedTeam Install Completed"
# Install Sysmon with 
echo "Installing Sysmon"
cmd /C mkdir c:\stuff
cp "T:\workshopsCreate_Threat_Research_Analysis_Systemsupport_files\Sysmon64.exe" c:\stuff\
cmd /C "c:\stuff\Sysmon64.exe" -i -accepteula
cmd /C "c:\stuff\Sysmon64.exe" -c "T:\sysmon-modular\sysmonconfig.xml"
echo "Sysmon Install Completed"
echo "Installing Velociraptor"
msiexec /i T:\velociraptor-docker\velociraptor\clients\windows\velociraptor_client.msi | Out-Null  
Start-Sleep -Seconds 45
rm "C:\Program Files\Velociraptor\client.config.yaml"
Copy-Item -Path "T:\velociraptor-docker\velociraptor\client.config.yaml" -Destination "C:\Program Files\Velociraptor\client.config.yaml"
cmd /C sc stop Velociraptor
cmd /C sc start Velociraptor
echo "Velociraptor Install Completed"
# Install Splunkforwarder
echo " Installing Splunkforwarder"
msiexec.exe /i t:\splunkforwarder.msi AGREETOLICENSE=Yes SPLUNKUSERNAME=admin SPLUNKPASSWORD=Passw0rd! RECEIVING_INDEXER="192.168.56.1:9997" /quiet | Out-Null
echo "Splunkforwarder Install Completed"
echo "Copying inputs.conf to Splunk Folder"
cp T:\workshopsCreate_Threat_Research_Analysis_Systemsupport_files\inputs.conf "C:\Program Files\SplunkUniversalForwarder\etc\apps\SplunkUniversalForwarder\local\inputs.conf"
echo "Restarting Splunkforwarder Service"
cmd /C sc stop SplunkForwarder
cmd /C sc start SplunkForwarder
# Unblock the installation script by running:
Unblock-File T:\flare-vm\install.ps1
# Enable script execution by running:
Set-ExecutionPolicy Unrestricted
# Install FlareVM
echo "Installing FlareVM"
# Finally, execute the installer script as follow:
T:\flare-vm\install.ps1 -password Passw0rd! -noGui
echo "FlareVM Install Completed"
