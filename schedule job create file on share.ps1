#Jobbtrigger
$trigger = New-JobTrigger -Daily -At 20:00 

#Jobbnamn
$name = "test backup"

#Vad ska ske
$action = {
net use T: /Delete
$date = Get-Date
$user = "backtest"
$PWord = ConvertTo-SecureString –String "Qwerty1234" –AsPlainText -Force
$Credential = New-Object –TypeName System.Management.Automation.PSCredential –ArgumentList $User, $PWord
$path = "T:\backtest.txt"
net use T: \\nas-sabac01\Backup_Active /user:backtest Qwerty1234
$date | Out-File -FilePath "t:\active.bac" -Append
net use T: /Delete
}

#Alternativ
$option = New-ScheduledJobOption -RequireNetwork -RunElevated 

#$cre = Get-Credential "huddinge\viklin"
#Skapa jobbet
Register-ScheduledJob -Name $name -ScriptBlock $action -Trigger $trigger -ScheduledJobOption $option -Credential $cre