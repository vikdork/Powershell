############################################
#Name:Count-users.ps1
#Author: Viktor Lindström
#
#
#Comments:Count users in specified administration
###########################################


function count-users{ 
<#
 
.SYNOPSIS
A function that counts users logged in against domain last 90 days. 
.DESCRIPTION
A function that counts users logged in against domain last 90 days in the different administrations.  
.EXAMPLE
 count-users -förvarltning msb
.NOTES
 
.LINK
 
http://powerhell.nu
 
#>

param(
[parameter(mandatory)]
[ValidateSet("Buf","Ksf","kuf","Msb","Säf","Samtliga")]
[string]$Förvaltning)


$date = get-date
$date2 = $date.AddDays(-104)
$Ou = @{"Buf"="OU=Buf,OU=Förvaltningar,OU=Data,DC=adm,DC=huddinge,DC=se";"Ksf"="OU=Ksf,OU=Förvaltningar,OU=Data,DC=adm,DC=huddinge,DC=se";"Kuf"="OU=kuf,OU=Förvaltningar,OU=Data,DC=adm,DC=huddinge,DC=se";"Msb"="OU=Msb,OU=Förvaltningar,OU=Data,DC=adm,DC=huddinge,DC=se";"Säf"="OU=Saf,OU=Förvaltningar,OU=Data,DC=adm,DC=huddinge,DC=se";"Samtliga"="OU=Förvaltningar,OU=Data,DC=adm,DC=huddinge,DC=se"}
$users = Get-ADUser -SearchBase $Ou.$Förvaltning -Filter *
$DCS = get-adforest
$domainsuffix = "*.adm.huddinge.se"
$result = @()


foreach ($user in $users)
{
$RealUserLastLogon = $null
$UserLastlogon = $null

foreach ($DomainController in $DCS.GlobalCatalogs)  
{ 

    if ($DomainController -like $domainsuffix ) 
    { 
        $UserLastlogon = Get-ADUser -Identity $user -Properties LastLogon -Server $DomainController
        if ($RealUserLastLogon -le [DateTime]::FromFileTime($UserLastlogon.LastLogon)) 
        { 
            $RealUserLastLogon = [DateTime]::FromFileTime($UserLastlogon.LastLogon) 
           
           
        } 
    } 
} 

if ($RealUserLastLogon -gt $date.AddDays(-90))
{$result += $user.sAMAccountName
 }
}
Write-Output "Sammanlagt har $($Förvaltning) $($result.Count) användare som loggat på domänen de senaste 90 dagarna. samanlagt finns $($users.Count) användare"
$result | Sort-Object -Descending |  Out-File c:\temp\$förvaltning.txt 

}
