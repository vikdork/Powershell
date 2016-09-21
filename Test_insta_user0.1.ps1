

function get-insta
{
param 
([string]$userid)

$accessToken = "209397487.73bb039.5d64cbfd30a54018bb10d3ef7097b936"

$id = ""

function search-user 
{
param ([string]$userid)

    
    $search = Invoke-RestMethod -uri "https://api.instagram.com/v1/users/search?q=$userId&access_token=$accessToken"
    $script:id = ($search.data | Where-Object {$_.username -eq $userid}).id
    
}
search-user -userid $userId


$user_full = Invoke-RestMethod -uri "https://api.instagram.com/v1/users/$script:id/media/recent/?access_token=209397487.73bb039.5d64cbfd30a54018bb10d3ef7097b936"
$user_full.data.images.standard_resolution
}



