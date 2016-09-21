#Import Active Directory Module.
Import-Module Activedirectory

#csvPath.
$csvPath = "C:\Scripts\ADGroupMember\ADGruppMedlemmar.CSV"

# List with included groups.
$adGroups = Get-Content C:\Scripts\ADGroupMember\Grouplist.txt


# function to get date when user added to group. 
function Get-AdGroupMemberDate 
{
    param (
            [string]$group
            )
            $groupDistinguishedName =  get-adgroup -Identity $group | Select-Object DistinguishedName
            Get-ADReplicationAttributeMetadata -Object $groupDistinguishedName.DistinguishedName -Server srvdc01 -ShowAllLinkedValues | Where-Object {$_.AttributeName  -EQ "member" -and $_.AttributeValue -notlike "*\0ADEL*" -and $_.AttributeValue -notlike "*OU=Karantan*" -and $_.AttributeValue -notlike "*{*"} | Select-Object AttributeValue, FirstOriginatingCreateTime 
    }

$result = @()
foreach ($adGroup in $adGroups)
{
    
   $distinguishedNameAndDates = @()
    
    $distinguishedNameAndDates += Get-AdGroupMemberDate -group $adGroup
        
        foreach ($item in $distinguishedNameAndDates)
        {
         $adResult = get-aduser -Identity $item.AttributeValue -Properties mail
         $Result += New-Object -TypeName PSObject -Property @{
         Name = $adResult.Name
         TimeCreated = $item.FirstOriginatingCreateTime
         Group = $adGroup
         mail = $adResult.mail
                                                             }
         }
}

$Result | Export-Csv -NoTypeInformation -Encoding UTF8 -Path $csvPath