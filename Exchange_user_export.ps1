# Filepath with uniqe date.
$date = get-date -Format yyyy.MM.dd
$result = "C:\backup\Resultat_" + $date +".txt"

# Get all mailboxes in Exchange, sort after database and name, select name and database and then export to text file.
Get-Mailbox -Resultsize Unlimited | Sort-Object database, name | Select-Object name, database | Export-csv $result  -NoTypeInformation

#Mail the text file to tekniker@huddinge.se
Send-MailMessage -Attachments $result -Subject "Users and Databases Exchange" -Body "Bifogad fil innehaller vilka anvandare som ligger pa vilken databas för tillfallet i Exchange" -To "tekniker@huddinge.se" -From "backup.exchange@huddinge.se" -SmtpServer "smtp-relay.adm.huddinge.se" 