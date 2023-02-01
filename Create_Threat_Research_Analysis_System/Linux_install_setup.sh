#!/bin/sh

# Get Repo
mkdir /home/$USER/tools/
cd /home/$USER/tools/
git clone https://github.com/paladin316/workshops.git


#Remnux Install
echo "Downloading and installing Remnux; Grab some coffee, this might take a while"
cd /home/$USER/tools/
wget https://REMnux.org/remnux-cli

# 23c7f4eefa7599ea2c4156f083906ea5fd99df18f306e4bb43eec0430073985a
sha256sum remnux-cli
cp remnux-cli remnux
chmod +x remnux
sudo mv remnux /usr/local/bin
sudo apt install -y gnupg
sudo remnux install -y

# Download Windows Tools
mkdir /home/$USER/tools/windows_tools
cd /home/$USER/tools/windows_tools
wget http://dl.google.com/chrome/install/375.126/chrome_installer.exe
wget https://download.sysinternals.com/files/SysinternalsSuite.zip

# InetSim Install (already installed as part of Remnux)
# sudo apt install inetsim

# Install foremost - forensics carving utility
tput setaf 5; echo "Installing foremost"
sudo apt install foremost -y

# Install Mingw to compile windows binaries on Linux
tput setaf 5; echo "Installing Mingw to compile windows binaries on Linux"
sudo apt-get install mingw-w64-x86-64-dev gcc-mingw-w64-x86-64 gcc-mingw-w64 -y

# Install Boxes for console Messages
sudo apt install boxes -y


# Install Velociraptor
# Install instructions can be found here https://github.com/weslambert/velociraptor-docker
tput setaf 5; echo "Installing Velociraptor"
sudo apt install docker-compose -y
cd /home/$USER/tools/
git clone https://github.com/weslambert/velociraptor-docker
cd /home/$USER/tools/velociraptor-docker
sudo docker-compose up -d 
tput setaf 5; echo "To access the Velociraptor Console browse to URL https://192.168.56.1:8889; username=admin password=admin"
sudo sed -i 's/-\ https:\/\/VelociraptorServer:8000\//-\ https:\/\/192.168.56.1:8000\//g' /home/$USER/tools/velociraptor-docker/velociraptor/client.config.yaml
# If you want to stop Velociraptor run command 'sudo docker-compose stop'
# Access the Velociraptor GUI via https://<hostip>:8889

# Create link to start/stop Velociraptor
chmod +x /home/$USER/tools/workshops/Create_Threat_Research_Analysis_System/support_files/start-velociraptor
chmod +x /home/$USER/tools/workshops/Create_Threat_Research_Analysis_System/support_files/stop-velociraptor
sudo ln -s /home/$USER/tools/workshops/Create_Threat_Research_Analysis_System/support_files/start-velociraptor /usr/bin/
sudo ln -s /home/$USER/tools/workshops/Create_Threat_Research_Analysis_System/support_files/stop-velociraptor /usr/bin/


# Default u/p is admin/admin
# This can be changed by running:
# docker exec -it velocraptor ./velociraptor --config server.config.yaml user add user1 user1 --role administrator

# Notes:
# Linux, Mac, and Windows binaries are located in /velociraptor/clients, which should be mapped to the host in the ./velociraptor directory if using docker-compose. There should also be versions of each automatically repacked based on the server   configuration.

# Once started, edit server.config.yaml in /velociraptor, then run docker-compose down/up for the server to reflect the changes

# Install VirtualBox
tput setaf 5; echo "installing VirtualBox"
sudo apt install virtualbox virtualbox-ext-pack -y

# Download MS VM
# Get Flare-VM 
tput setaf 5; echo "Donwloaing some tools, FlareVM, AtomicRedteam, Sysmon"
cd /home/$USER/tools/
git clone https://github.com/mandiant/flare-vm.git

# Get Atomic Red Team
cd /home/$USER/tools/
git clone https://github.com/redcanaryco/atomic-red-team.git
git clone https://github.com/redcanaryco/invoke-atomicredteam.git

# Get Sysmon
cd /home/$USER/tools/workshops/Create_Threat_Research_Analysis_System/support_files/
wget -O Sysmon.zip https://download.sysinternals.com/files/Sysmon.zip
unzip Sysmon.zip
cd /home/$USER/tools/
git clone https://github.com/olafhartong/sysmon-modular.git
# Get Win10 Dev VM for IE
cd /home/$USER/tools/
tput setaf 5; echo "Downloading Win10 Dev VM for IE; Grab some coffee, this might take a while"
wget -O WinDev2301Eval.VirtualBox.zip https://aka.ms/windev_VM_virtualbox
sleep 10
unzip WinDev2301Eval.VirtualBox.zip


# Get Office 2019
#cd /home/$USER/tools/
#tput setaf 5; echo "Downloading Office Pro Plus 2019, this might take a while"
#wget http://officecdn.microsoft.com/pr/492350f6-3a01-4f97-b9c0-c7c6ddf67d60/media/nl-nl/ProPlus2019Retail.img
#7z x 'ProPlus2019Retail.img' -o/home/$USER/tools/Office2019

# Extract VMDK Disk from OVA file to prep for FlareVM
tput setaf 5; echo "Extracting VMDK Disk from OVA file to prep for FlareVM"
mkdir /home/$USER/tools/OVA-temp
mkdir /home/$USER/tools/P316-ThreatResearch
7z x 'WinDev2301Eval.ova' -o/home/$USER/tools/OVA-temp
cd /home/$USER/tools/OVA-temp
rm /home/$USER/tools/OVA-temp/'WinDev2301Eval.ovf'
mv /home/$USER/tools/OVA-temp/'WinDev2301Eval-disk001.vmdk' /home/$USER/tools/OVA-temp/P316-ThreatResearch.vmdk

# Convert VMDK image to VDI image; This is required to expand the dynamic disk size to install FlareVM
tput setaf 5; echo "Convert VMDK image to VDI image; This is required to expand the dynamic disk size to install FlareVM"
VBoxManage clonehd --format VDI /home/$USER/tools/OVA-temp/P316-ThreatResearch.vmdk  /home/$USER/tools/P316-ThreatResearch/P316-ThreatResearch.vdi
cd /home/$USER/tools/P316-ThreatResearch

# Create Virtual Machine via command line 
tput setaf 5; echo "Creating Virtual Machine"
vboxmanage createvm --name P316-ThreatResearch --ostype Windows_64 --register --basefolder /home/$USER/tools/ &&
VBoxManage modifyvm P316-ThreatResearch --firmware efi &&
vboxmanage modifyvm P316-ThreatResearch --memory 4096 --cpus 2 --vram 128 --graphicscontroller VBoxSVGA &&
VBoxManage storagectl P316-ThreatResearch --name "SATA Controller" --add sata --bootable on &&
VBoxManage storageattach P316-ThreatResearch --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium /home/$USER/tools/P316-ThreatResearch/P316-ThreatResearch.vdi &&
VBoxManage storagectl P316-ThreatResearch --name "IDE Controller" --add ide
VBoxManage modifyvm P316-ThreatResearch --nic1 hostonly --hostonlyadapter1 vboxnet0

# Option to run VM in headless mnode; this will setup RDP access instead of running the gui directly 
# Remote Desktop enabled on port 10001 (useful for administration on an headless environment).
# VBoxManage modifyvm P316-ThreatResearch --vrde on                  
# VBoxManage modifyvm P316-ThreatResearch --vrdemulticon on --vrdeport 10001
# VBoxHeadless --startvm P316-ThreatResearch

# Create VBox Hostonly Interface
VBoxManage hostonlyif create &&
VBoxManage hostonlyif ipconfig vboxnet0 --ip 192.168.56.1 &&
VBoxManage dhcpserver add --ifname vboxnet0 --ip 192.168.56.1 --netmask 255.255.255.0 --lowerip 192.168.56.100 --upperip 192.168.56.200 &&
VBoxManage dhcpserver modify --ifname vboxnet0 --enable

# Create Share Folders for Win10 VM
VBoxManage sharedfolder add P316-ThreatResearch -name tools -hostpath "/home/$USER/tools" --readonly  --automount --auto-mount-point="t:"
mkdir /home/$USER/tshare
VBoxManage sharedfolder add P316-ThreatResearch -name tshare -hostpath "/home/$USER/tshare" --automount --auto-mount-point="s:"

# Increase Disk Size of the VM to install Flare-VM Tools
VBoxManage modifyhd /home/$USER/tools/P316-ThreatResearch/P316-ThreatResearch.vdi --resize 1000000

# Create vm hostonly/nat link to change interfaces
chmod +x /home/$USER/tools/workshops/Create_Threat_Research_Analysis_System/support_files/vm-set-hostonly
chmod +x /home/$USER/tools/workshops/Create_Threat_Research_Analysis_System/support_files/vm-set-nat
sudo ln -s /home/$USER/tools/workshops/Create_Threat_Research_Analysis_System/support_files/vm-set-hostonly /usr/bin/
sudo ln -s /home/$USER/tools/workshops/Create_Threat_Research_Analysis_System/support_files/vm-set-nat /usr/bin/

# Cleanup of larger files no longer needed
rm /home/$USER/tools/WinDev2301Eval.ova
rm /home/$USER/tools/WinDev2301Eval.VirtualBox.zip
# Set up Velociraptor agent


#Install Splunk 
cd /home/$USER/tools/
wget -O splunk-9.0.3-dd0128b1f8cd-linux-2.6-amd64.deb "https://download.splunk.com/products/splunk/releases/9.0.3/linux/splunk-9.0.3-dd0128b1f8cd-linux-2.6-amd64.deb"
wget -O splunkforwarder.msi "https://download.splunk.com/products/universalforwarder/releases/9.0.3/windows/splunkforwarder-9.0.3-dd0128b1f8cd-x64-release.msi"
cat ~/tools/message.txt
zenity --error --text="Install Script Finished - See console for next steps\!" --title="Script Setup Completed!"

tput setaf 5; echo "Have you logged into Splunk and downloaded Splunk installer and Splunkforwarder binary? If yes then continue"
read -n 1 -r -s -p $'Press enter to continue...\n'
#MV Splunk Forwarder binary to tools dir
# Install Splunk
tput setaf 5; echo "Installing Splunk"
sudo dpkg -i /home/$USER/tools/splunk*.deb
tput setaf 5; echo "Starting Splunk"
chmod +x /home/$USER/tools/workshops/Create_Threat_Research_Analysis_System/support_files/start-splunk 
sudo ln -s /home/$USER/tools/workshops/Create_Threat_Research_Analysis_System/support_files/start-splunk /usr/bin/
chmod +x /home/$USER/tools/workshops/Create_Threat_Research_Analysis_System/support_files/stop-splunk 
sudo ln -s /home/$USER/tools/workshops/Create_Threat_Research_Analysis_System/support_files/stop-splunk /usr/bin/
sudo /opt/splunk/bin/splunk start --accept-license
#Create username (admin) and password (Passw0rd!) when prompted during the Splunk install
# Velociraptor is currently using http port [8000]; You'll need to supply another port number. I'd suggest suggest using port 8888
# After Splunk starts up login using the credential created during the install at URL http://system1:8888
tput setaf 5; echo "Stopping Splunk"
sudo /opt/splunk/bin/splunk stop
tput setaf 5; echo "Splunk Install Completed; To start Splunk run command start-splunk else stop-splunk to shutdown the Splunk server"
tput setaf 5; echo "You can access Splunk using this URL http://127.0.0.1:8888; Use the username and password you created during the install"
tput setaf 5; echo "Next steps, laucnh the Windows 11 VM and continue with the Windows portion of the setup"
