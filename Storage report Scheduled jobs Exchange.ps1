#Jobbtrigger
$trigger = New-JobTrigger -Daily -At 22:00 

#Jobbnamn
$name = "Create storage report"

#Vad ska ske
$action = {# Sökväg till export
                         $exportPath = "\\srv-fil05\IT-sektionen\Arbetsdokument\IT Drift\IT Server\Lagring_rapporter\Exchange.csv"
                         
                         # Importera Exchange commandlets
                         Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn
                         
                         # Hämta data för samtliga databaser
                         $mailboxDatabases = Get-MailboxDatabase -Status | select-object databasesize, name
                         $result = @()
                         
                         foreach ($database in $mailboxDatabases)
                         {
                             $result += New-Object psobject -Property @{
                                                             'Database' = $database.name
                                                             'Databasesize' = $database.DatabaseSize.ToGB()
                                                             'Date' = get-date -f d
                                                             }
                         }
                         
                         # Exportera resultatet till G:
                         $result | Export-Csv -Path $exportPath -Encoding UTF8 -Delimiter ";" -NoTypeInformation -Append

}

#Alternativ
$option = New-ScheduledJobOption -RequireNetwork -RunElevated

#sätt en cred innan som har rättigheter i exchange och på sharet. 
#$cred = Get-Credential

#Skapa jobbet
Register-ScheduledJob -Name $name -ScriptBlock $action -Trigger $trigger -ScheduledJobOption $option -Credential $cred