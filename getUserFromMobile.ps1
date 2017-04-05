function Get-Mobile 
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory=$true)]
        [ValidateLength(9,15)]
        [String]$mobileNumber
    )
        $server = "srv-adlds01.adm.huddinge.se"
        $base = "DC=huddinge,DC=ldap"
        $mobileNumber = $mobileNumber.substring($mobileNumber.length - 9, 9)
        $getUserFromMobile = Get-ADobject -Credential $cred -Filter "mobile -like '*$mobileNumber*'" -Server $server -SearchBase $base -Properties *
        $user = get-aduser $getUserFromMobile.cn 
            if (-not $user.Count)
            {write-host "sätter lösen för $($user.name)"}
            else
            {write-host "Något blev fel det fans flera anändare och dessa är $($user.name)"}
    }
Get-Mobile -mobileNumber 0709750555
$mobileNumber = "0709750555"
#$cred = Get-Credential

$user.count








