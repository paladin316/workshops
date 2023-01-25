

#Remnux Install
echo "Downloading and installing Remnux; Grab some coffee, this might take a while"
wget https://REMnux.org/remnux-cli

# 23c7f4eefa7599ea2c4156f083906ea5fd99df18f306e4bb43eec0430073985a
sha256sum remnux-cli
cp remnux-cli remnux
chmod +x remnux
sudo mv remnux /usr/local/bin
sudo apt install -y gnupg
sudo remnux install

# InetSim Install (already installed as part of Remnux)
# sudo apt install inetsim

# Install foremost - forensics carving utility
echo "Installing foremost"
sudo apt install foremost

# Install Mingw to compile windows binaries on Linux
echo "Installing Mingw to compile windows binaries on Linux"
sudo apt-get install mingw-w64-x86-64-dev gcc-mingw-w64-x86-64 gcc-mingw-w64

# Install Boxes for console Messages
sudo apt install boxes


# Install Velociraptor
# Install instructions can be found here https://github.com/weslambert/velociraptor-docker
echo "Installing Velociraptor"
sudo apt install docker-compose -y
mkdir /home/$USER/tools/
cd /home/$USER/tools/
git clone https://github.com/weslambert/velociraptor-docker
cd /home/$USER/tools/velociraptor-docker
sudo docker-compose up -d 
sudo sed -i 's/-\ https:\/\/VelociraptorServer:8000\//-\ https:\/\/192.168.56.1:8000\//g' /home/$USER/tools/velociraptor-docker/velociraptor/client.config.yaml
# If you want to stop Velociraptor run command 'sudo docker-compose stop'
# Access the Velociraptor GUI via https://<hostip>:8889

# Default u/p is admin/admin
# This can be changed by running:
# docker exec -it velocraptor ./velociraptor --config server.config.yaml user add user1 user1 --role administrator

# Notes:
# Linux, Mac, and Windows binaries are located in /velociraptor/clients, which should be mapped to the host in the ./velociraptor directory if using docker-compose. There should also be versions of each automatically repacked based on the server   configuration.

# Once started, edit server.config.yaml in /velociraptor, then run docker-compose down/up for the server to reflect the changes

# Install VirtualBox
echo "installing VirtualBox"
sudo apt install virtualbox virtualbox-ext-pack -y --force-yes

# Download MS VM
# Get Flare-VM 
echo "Donwloaing some tools, FlareVM, AtomicRedteam, Sysmon"
cd /home/$USER/tools/
git clone https://github.com/mandiant/flare-vm.git

# Get Atomic Red Team
cd /home/$USER/tools/
git clone https://github.com/redcanaryco/atomic-red-team.git
git clone https://github.com/redcanaryco/invoke-atomicredteam.git

# Get Sysmon
cd /home/$USER/tools/
git clone https://github.com/olafhartong/sysmon-modular.git

# Get Win10 Dev VM for IE
cd /home/$USER/tools/
echo "Downloading Win10 Dev VM for IE; Grab some coffee, this might take a while"
wget https://az792536.vo.msecnd.net/vms/VMBuild_20190311/VirtualBox/MSEdge/MSEdge.Win10.VirtualBox.zip
unzip MSEdge.Win10.VirtualBox.zip

# Get Office 2019
cd /home/$USER/tools/
echo "Downloading Office Pro Plus 2019, this might take a while"
wget http://officecdn.microsoft.com/pr/492350f6-3a01-4f97-b9c0-c7c6ddf67d60/media/nl-nl/ProPlus2019Retail.img
7z x 'MSEdge - Win10.ova' -o/home/$USER/tools/Office2019

# Extract VMDK Disk from OVA file to prep for FlareVM
echo "Extracting VMDK Disk from OVA file to prep for FlareVM"
mkdir /home/$USER/tools/OVA-temp
mkdir /home/$USER/tools/P316-ThreatResearch
7z x 'MSEdge - Win10.ova' -o/home/$USER/tools/OVA-temp
cd /home/$USER/tools/OVA-temp
rm /home/$USER/tools/OVA-temp/'MSEdge - Win10.ovf'
mv /home/$USER/tools/OVA-temp/'MSEdge - Win10-disk001.vmdk' /home/$USER/tools/OVA-temp/P316-ThreatResearch.vmdk

# Convert VMDK image to VDI image; This is required to expand the dynamic disk size to install FlareVM
echo "Convert VMDK image to VDI image; This is required to expand the dynamic disk size to install FlareVM"
VBoxManage clonehd --format VDI /home/$USER/tools/OVA-temp/P316-ThreatResearch.vmdk  /home/$USER/tools/P316-ThreatResearch/P316-ThreatResearch.vdi
cd /home/$USER/tools/P316-ThreatResearch

# Create Virtual Machine via command line 
echo "Creating Virtual Machine"
vboxmanage createvm --name P316-ThreatResearch --ostype Windows_64 --register --basefolder /home/$USER/tools/ &&
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
VBoxManage sharedfolder add P316-ThreatResearch -name tools -hostpath "/home/user/tools" --readonly  --automount --auto-mount-point="t:"
mkdir /home/$USER/tshare
VBoxManage sharedfolder add P316-ThreatResearch -name tshare -hostpath "/home/user/tshare" --automount --auto-mount-point="s:"

# Increase Disk Size of the VM to install Flare-VM Tools
VBoxManage modifyhd /home/$USER/tools/P316-ThreatResearch/P316-ThreatResearch.vdi --resize 1000000

# Set up Velociraptor agent


#Install Splunk 
zenity --error --text="Install Script Finished - See console for next steps\!" --title="Script Setup Completed!"
cat ~/tools/message.txt

To install Splunk go to https://www.splunk.com/en_us/download/splunk-enterprise.html;
Create an account if you do not have one. Next peform the following steps:
1. Donwload Splunk binary for Linux from here https://www.splunk.com/en_us/download/splunk-enterprise.html?locale=en_us#
2. | boxes -d peek
https://www.splunk.com/en_us/download/splunk-enterprise.html
https://docs.splunk.com/Documentation/Splunk/9.0.2/Admin/MoreaboutSplunkFree
echo "Have you logged into Splunk and downloaded Splunk installer and Splunkforwarder binary? If yes then continue"
read -n 1 -r -s -p $'Press enter to continue...\n'
#MV Splunk Forwarder binary to tools dir
mv /home/$USER/Downloads/splunkforwarder*.msi /home/$USER/tools/splunkforwarder.msi

# To Dos:
# 1. Capture Diskmanager extend process
# 2. Rename user prior to flare vm install - (Get-WmiObject Win32_UserAccount -Filter "name='IEUser'").Rename("User1")
