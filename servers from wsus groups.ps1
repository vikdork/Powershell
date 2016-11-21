# get all wsus groups
$wsusGroups = Get-ADGroup -filter 'name -like "*wsus*"'

# Create empty result array 
$result = @()

# Collect computers from AD-groups
    foreach ($group in $wsusGroups)
        {
           # Collect wsus group members
           $members = Get-ADGroupMember -Identity $group.name
                    
                    # Fill result variable with group and computer name
                    foreach ($item in $members)
                    {
                       $result += New-Object psobject -Property @{
                            "PatchSchema" = $group.name
                            "Servernamn" = $item.name 
                                                                 }
                    }
         }

