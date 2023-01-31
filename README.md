# workshops
This repo is where I'm storing my workshop content

The steps for building the Threat Research System are as follows:

The base host I used for this project is a Kubuntu 20.04

This script will install the necessary files used to build the based OS and the files used to build the Windows 11 VM (Unfortuately Windows 10 Dev VM is no longer available). The total install time is about 4 - 6 hours depending on your Internet bandwith. Most of the install is automated excpet for some of the Windows setup steps, but even most of that is automated as well.


Install Steps:

1. On the base host run script "Linux_install_setup.sh"
2. Once the script completes run start the Windows VM. Be sure to create a snapshot in case you need to start over.
3. After auto logging into the Windows 11 VM, open an Admin PowerShell prompt, navigate to the "t:" drive.
