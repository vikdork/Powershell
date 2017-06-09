function MyFunction ($param1, $param2)
{
    
}

$cred = Get-Credential
$server = "test-adlds01.adm.huddinge.se"
$base = "DC=huddfed,DC=adlds"

$test = Get-ADobject -Credential $cred -Filter 'name -eq "abdal30"'  -Server ($server + ":389") -SearchBase $base -Properties *

Get-ADGroupMember -Credential $cred -Identity $test.DistinguishedName -Server ($server + ":389")
"CN=antarv,OU=Std,OU=Users,OU=KSF,OU=Förvaltningar,OU=Data,DC=huddfed,DC=adlds"