#Jobbtrigger
$trigger = New-JobTrigger -Daily -At 21:00 

#Jobbnamn
$name = "Create EMC storage report"

#Vad ska ske
$action = {
# Man behöver lägga in ESPIPSToolkit på servern som ska köra det här.
$user = @{"Username"="emcstats";"Password"="HZr9h5Ubx4VLCgJj7Pce";"SpaIpAddress"="172.16.10.179";"SpbIpAddress"="172.16.10.180"; "UserFriendlyName"="VNX-x"};
connect-emcsystem -SystemType "vnx-block" -CreationParameters $user
$resultat = Get-EmcStoragePool data* | Select-Object TotalCapacity, AvailableCapacity, SubscribedCapacity, @{Name="Date"; Expression ={get-date}}

$resultat | Export-Csv 'G:\IT-sektionen\Arbetsdokument\IT Drift\IT Server\Lagring_rapporter\EMC.csv' -Encoding UTF8 -Delimiter ";" -Append -NoTypeInformation

}

#Alternativ
$option = New-ScheduledJobOption -RequireNetwork -RunElevated

#$cred = Get-Credential

#Skapa jobbet
Register-ScheduledJob -Name $name -ScriptBlock $action -Trigger $trigger -ScheduledJobOption $option -Credential $cred