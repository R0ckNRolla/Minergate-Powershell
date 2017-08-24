# Minergate Deployment and Running

Install and Run Minergate-CLI in Hidden Mode

_Host_: https://api.minergate.com

### Introduction

This project I undertook while running a small graphics powered farm while I was improving on my coding skills. I will slowly update all the source code I used to install and deploy and monitor my farm. 

Please do NOT use this without the consent of the person who owns the computer. This code is NOT to be used for malicious purposes. 

### Using this Powershell Script

#### 1. Download Install_Minergate.ps1 and Edit the Code

Download Install_Minergate.ps1 and place it in your C:\ Directory. Register an account with Minergate.com and replace the email address with your own in the code. To edit the code right click the file and click edit.

#### 2. Lunch Powershell in Administrator Mode

Click on Start and type Powershell -> Right click on "Windows Powershell" and then "Run as Administrator"

#### 3. Set Execution Policy and Execute the Script

By default Windows does not allow the execution of Powershell scripts. This is by design to stop remote/local execution out of the box for hackers to take advantage of. You must launch Powershell in Administrator mode and type the following: (Without "")

"cd \" Press Enter
"_Set-ExecutionPolicy Unrestricted_" Press Enter

Powershell will then ask:

#####Execution Policy Change
The execution policy helps protect you from scripts that you do not trust. Changing the execution policy might expose
you to the security risks described in the about_Execution_Policies help topic at
http://go.microsoft.com/fwlink/?LinkID=135170. Do you want to change the execution policy?
[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "N"): 

You need to choose: "[A] Yes to All" Press A

![Alt text](https://github.com/MetalH47K/Minergate-Powershell/blob/master/Set-ExecutionPolicy%20Unrestricted.PNG?raw=true "Set-ExecutionPolicy Unrestricted")

Now you are ready to execute the script. Simply type without brackets ".\Install_Minergate.ps1"
