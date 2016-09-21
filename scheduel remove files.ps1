#Jobbtrigger
$trigger = New-JobTrigger -Weekly -DaysOfWeek Monday -WeeksInterval 1 -At 21:00 

#Jobbnamn
$name = "Remove NPS Logs"

#Vad ska ske
$action = {
#Variables 
$logPath = "C:\Windows\System32\LogFiles\*"
$todaysDate = get-date

#Collect files older than 30 days
$oldLogFiles = Get-ChildItem -Filter "IN*" -Path $log -Include *.log | Where-Object LastWriteTime -LT $todaysDate.AddDays(-30)

# Remove All files older than 30 days, with extra check that only files with correct directory is removed if any other file sliped in on misstake.
foreach ($oldFile in $oldLogFiles)
{
    if ($oldFile.DirectoryName -eq "C:\NPS\LogFiles")
        {
            Write-Host "Removing $($oldFile)"
            $oldFile | Remove-Item
        }
    else
        {
            Write-Host "Filen ligger i fel katalog, kolla skriptet något är fel."
            }
}

}

#Alternativ
$option = New-ScheduledJobOption -RequireNetwork -RunElevated

#Skapa jobbet
Register-ScheduledJob -Name $name -ScriptBlock $action -Trigger $trigger 


