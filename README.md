# Workshops

The goal of this first workshop is to help others learn how to build a Threat Research Analysis system on the cheap. Then use this System as the foundation for building on the other Workshops that are part of this series.  See the Wiki for other workshops that will be presented as part of this series https://github.com/paladin316/workshops/wiki

The steps for building the Threat Research System are as follows:

The base host I used for this project is a Kubuntu 20.04 (Some may prefer Ubuntu 20.04, that will work too)

This script will install the necessary files used to build the base analysis system and the files used to build the Windows 11 VM (Unfortuately Windows 10 Dev VM is no longer available). The total install time is about 4 - 6 hours depending on your Internet bandwith. Most of the install is automated excpet for some of the Windows setup steps, but even most of that is automated as well.


Install Steps:

1. On the base host run command "chmod +x Linux_install_setup.sh", then execute the script by running "./Linux_install_setup.sh" (Without the quotes).
2. During the VirtualBox install you'll be prompted to accept the VirtualBox License.
3. During the Splunk install, you'll be prompted to enter a username and password. You'll also be prompted to change the Splunk port since its being used by Velocripator, respond with "y" and enter "8888" for the port number. Note: This is the Splunk Community version which only allows 500MB per day. I would suggest only running the Splunk server during testing to avoid reaching the daily limit. Otherwise you'll lose your data. To start Splunk run command start-splunk else stop-splunk to shutdown the Splunk server. 
4. Once the script completes, start the Windows VM. Be sure to create a snapshot in case you need to start over.
5. After auto logging into the Windows 11 VM, open an Admin PowerShell console, navigate to the "t:" drive. Then to folder "T:\workshops\Create_Threat_Research_Analysis_System\support_files\". 
6. Next run, file "create_user.bat"
7. After the VM restarts, change the network setting to NAT, then login using Username=P316 and Password=Passw0rd!
8. Start an Admin PowerShell console, then navigate again to "T:\workshops\Create_Threat_Research_Analysis_System\support_files\" and run file "windows-setup.bat"
9. After a couple of hours the install should be finished. This is where "Workshop 1 - Create Analysis System" will pick up from to review the tools installed and the following:

High level review of the tools and use cases

* Sysmon / Splunk Logging
* Malware Analysis, , CaptureBat Python
* Remnux
* FlareVM
* Atomic Red Team
* RTO
* Velocirptor
* Threat Hunting
* Detection Engineering

Discuss Dos and Don'ts , talk about OpSec
* Use a VPN to hide your true IP - why? Methods?
* Do not connect or interact directly with attacker infrastructure - why ?
* Don't tip off the Threat Actor - why?
* Use Open Source Intelligence (OSINT) tools to research (Yes Google can be used as OSINT)

