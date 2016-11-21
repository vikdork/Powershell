#Jobbtrigger
$trigger = New-JobTrigger -Daily -DaysInterval 1 -At 21:00 

#Jobbnamn
$name = "Create TSM storage report"

#Vad ska ske
$action = {
Set-Location -Path 'C:\Program Files\Tivoli\TSM\baclient'
$test = .\dsmadmc.exe -id=admvili -password=Sommar2016 Query STGpool | select -skip 16 | select -First 5 | ConvertFrom-String  | Where-Object {$_.P1 -eq "BACKUPPOOL" -or $_.P1 -eq "COPYPOOL"} 
$exportPath = "\\srv-fil05\IT-sektionen\Arbetsdokument\IT Drift\IT Server\Lagring_rapporter\TSM.csv"
$result = @()

foreach ($item in $test)
{
    $sizeInGb = $item.p4.ToString() + $item.p5.ToString()
    [int]$sizeInGbInt = $sizeInGb 

    
    
    $result += New-Object psobject -Property @{
                                    'Pool' = $item.P1
                                    'SizeInGB' = $sizeInGb
                                    'PercentUtilization' = ($item.p7/1000)*100
                                    'GBUtilization' = $sizeInGbInt * ($item.p7/1000)
                                    'GBsFree' = $sizeInGbInt - ($sizeInGbInt * ($item.p7/1000))
                                    'Date' = get-date -Format d
                                    }
                                   
}
$result | Export-Csv $exportPath -Encoding UTF8 -NoClobber -Delimiter ";" -NoTypeInformation -Append

}

#Alternativ
$option = New-ScheduledJobOption -RequireNetwork -RunElevated

#$cred = Get-Credential

#Skapa jobbet
Register-ScheduledJob -Name $name -ScriptBlock $action -Trigger $trigger -ScheduledJobOption $option -Credential $cred