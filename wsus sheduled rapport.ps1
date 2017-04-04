#Jobbtrigger
$trigger = New-JobTrigger -Daily -At 20:00 

#Jobbnamn
$name = "Wsus Groups"

#Vad ska ske
$action = {
$groups = get-adgroup -Filter 'name -like "*wsus*"'

$a = "<style>"
$a = $a + "BODY{background-color:#f1f2f2;}"
$a = $a + "TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}"
$a = $a + "TH{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color:thistle}"
$a = $a + "TD{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color:PaleGoldenrod}"
$a = $a + "</style>"


$resultat = @()

foreach ($group in $groups)
{
    $computers = Get-ADGroupMember -Identity $group
       foreach ($computer in $computers)
       {
       
   
       $resultat += New-Object psobject  -Property @{
                    'Computername' = $computer.name
                    'Group' = $group.Name 
                    }
        }
}

$resultat | Sort-Object computername -Descending | ConvertTo-Html -Head $a | Out-File \\srv-dok01\filarkiv\Rapporter\wsus.html
get-date | Out-File -FilePath \\srv-dok01\filarkiv\Rapporter\wsus.html -Append
}

#Alternativ
$option = New-ScheduledJobOption -RequireNetwork

#$cre = Get-Credential "huddinge\viklin"
#Skapa jobbet
Register-ScheduledJob -Name $name -ScriptBlock $action -Trigger $trigger -ScheduledJobOption $option
