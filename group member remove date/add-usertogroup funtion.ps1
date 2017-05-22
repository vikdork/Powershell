    function add-usertogroup
    {
    param(
    [parameter(mandatory=$true)]
    $user,
    [parameter(mandatory=$true)]
    $group)

    $aduser = get-aduser $user 
    $adgroup = get-adgroup $group
    Add-ADGroupMember -Identity $adgroup -Members $aduser
    }