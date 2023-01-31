:: Add new user and set password
net user P316 Passw0rd! /add

:: Add new user to admin group
net localgroup administrators P316 /add

:: Deavtivate MS Default User
net user User /active:no

:: Restart Computer
cmd /C powershell.exe Restart-Computer
