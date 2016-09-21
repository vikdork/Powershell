function get-UsersFromGroup 
{
param
([parameter(mandatory)]
[ValidateSet("srv-rcard01","srv-rds02","srv-procapts01")]
[string] $server)

# Variables for date and exportfile-summary
$date = get-date -Format d
$outfile = "C:\temp\Sammanfattning $server $date.txt"
$tempdir = "C:\temp"

# Get users from AD group depending on server.
switch ($server) {
srv-rcard01 {$users = Get-ADGroupMember "r-card_srv-rco01"}
srv-rds02 {$users = Get-ADGroupMember "BG Fjärrskrivbord" }
#Since 2 groups with some users in both broups I do a sort-object and unique
srv-procapts01 {$group1 = Get-ADGroupMember Procapita-Funktion-Remoteapp
$group2 = Get-ADGroupMember Procapita-Aldreoms-Remoteapp
$userspro = $group1 + $group2 
$users = $userspro | Sort-Object | Get-Unique}
}

#Get users from group
$users2 = $users | Get-ADUser -properties * -ErrorAction SilentlyContinue

#build empty arrays
$KSF = @()
$SAF = @()
$BUF = @()
$KUF = @()
$NBF = @()
$Övriga = @()
$Externa = @()
$Adm = @()

#Sort by apartment.
foreach ($user in $users2)
{if($user.DistinguishedName -like "*OU=KSF*")
{$KSF +=$user}
 elseif ($user.DistinguishedName -like "*OU=SAF*")
{$SAF +=$user}
 elseif
($user.DistinguishedName -like "*OU=BUF*")
{$BUF +=$user}
 elseif
($user.DistinguishedName -like "*OU=KUF*")
{$KUF +=$user}
 elseif
($user.DistinguishedName -like "*OU=NBF*")
{$NBF +=$user}
else
{$Övriga +=$user}
}

#capture external users
foreach ($use in $users2)
{
$userchar = $use.SamAccountName | Measure-Object -Character
if ($use.samaccountname -match "^[xyz]" -and $userchar.Characters -gt "6")
{$Externa +=$use
}
  }

  foreach ($use in $users2)
{
$userchar = $use.SamAccountName | Measure-Object -Character
if ($use.samaccountname -like "*adm*")
{$Adm +=$use
}
  }

#räkna ut hur många användare som är externa och adm och vanliga
$överiga2 = $adm + $Externa
$users3 = $users2.count - $överiga2.count

# Write result.
Write-host Sammanlagt är det $users2.count användare
write-host KSF har $ksf.count användare
write-host SAF har $saf.count användare
write-host BUF har $Buf.count användare
write-host KUF har $kuf.count användare
write-host NBF har $nbf.count användare
write-host Övriga användare är $övriga.count stycken
write-host Externa användare är $Externa.count stycken
write-host administratörer är $Adm.count stycken
write-host Användare exklusive administratörer och externa $Users3 stycken

#Delete summary-file if it exists.
if (test-path $outfile)
{Remove-Item -Path $outfile
    
}

#Check if dircetory c:\temp exist and if not create it.
if ( -Not (Test-Path $tempdir))
 { New-Item -Path $tempdir -ItemType Directory
 }

# Output count-result to file.

foreach ($item in $collection)
{
    
}


Write-Output "Sammanlagt är det $($users2.count) användare" | Out-File $outfile -Append
Write-Output "NBF har $($nbf.count) användare" | Out-File $outfile -Append
Write-Output "SAF har $($saf.count) användare" | Out-File $outfile -Append
Write-Output "BUF har $($Buf.count) användare" | Out-File $outfile -Append
Write-Output "KUF har $($kuf.count) användare" | Out-File $outfile -Append
Write-Output "NBF har $($NBF.count) användare" | Out-File $outfile -Append
Write-Output "Övriga användare är $($övriga.count) stycken" | Out-File $outfile -Append
Write-Output "Externa användare är $($Externa.count) stycken" | Out-File $outfile -Append
Write-Output "Administratörer är $($Adm.count) stycken" | Out-File $outfile -Append
Write-Output "Användare exklusive administratörer och externa $($users3) stycken" | Out-File $outfile -Append
  



#Export to CSV to c:\temp\
Write-Host Exporterar alla användare till CSV som läggs i c:\temp\[förvaltning.csv]
$nbf | select SamAccountName, GivenName, SurNAme, Description | Export-Csv c:\temp\nbf-$server.csv -NoTypeInformation -Encoding UTF8 -Delimiter ";"
$ksf | select SamAccountName, GivenName, SurNAme, Description | Export-Csv c:\temp\ksf-$server.csv -NoTypeInformation -Encoding UTF8 -Delimiter ";"
$buf | select SamAccountName, GivenName, SurNAme, Description | Export-Csv c:\temp\buf-$server.csv -NoTypeInformation -Encoding UTF8 -Delimiter ";"
$kuf | select SamAccountName, GivenName, SurNAme, Description | Export-Csv c:\temp\kuf-$server.csv -NoTypeInformation -Encoding UTF8 -Delimiter ";"
$saf | select SamAccountName, GivenName, SurNAme, Description | Export-Csv c:\temp\saf-$server.csv -NoTypeInformation -Encoding UTF8 -Delimiter ";"
$Övriga | select SamAccountName, GivenName, SurNAme, Description | Export-Csv c:\temp\övriga-$server.csv -NoTypeInformation -Encoding UTF8 -Delimiter ";"
$Externa | select SamAccountName, GivenName, SurNAme, Description | Export-Csv c:\temp\externa-$server.csv -NoTypeInformation -Encoding UTF8 -Delimiter ";"
$Adm | select SamAccountName, GivenName, SurNAme, Description | Export-Csv c:\temp\adm-$server.csv -NoTypeInformation -Encoding UTF8 -Delimiter ";"



#Capture if there is a group in the result.
foreach ($grupp in $users)
{
if ($grupp.objectclass -like "group") {Write-Host det finns en grupp som heter $grupp.name -BackgroundColor Red }
    }
}