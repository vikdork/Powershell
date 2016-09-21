Import-Module Activedirectory
# get date and time tog get the backup unique.
$date = get-date -Format yyyymmddHHmm
# Samla in användare som har 99999 som telefonnummer
# Collect users that hav 99999 as telephonenumber attribute.
$users = Get-ADUser -filter 'telephoneNumber -like "99999"' -Properties *

# Check if backup-file exists, if it exists stop the script and alert the usr, if it not exists export all users that is about to get the attribute changed.
if (Test-Path c:\temp\backup_$date.txt)
{Write-Host  "vänta en minut backupfilen finns redan" -BackgroundColor Yellow -ForegroundColor Red
    
}

else
{
Write-Host "exporterar användare" -BackgroundColor Black -ForegroundColor White
$users | Export-Csv c:\temp\backup_$date.txt -Encoding UTF8 -NoTypeInformation

foreach ($user in $users)
{
Write-Host "Clearing attribute on $user"
  Set-ADUser -Identity $user -Clear telephoneNumber
}
} 
