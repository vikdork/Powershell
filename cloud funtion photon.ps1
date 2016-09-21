$deviceId = "17002c001747343338333633"
$accessToken = "32988aca0dfa95283696e380e3e8535ae34d71c6"



function set-photon
{
    param(
    [ValidateSet("On", "Off", "Blink")]
   [string]$Turn, 
   [parameter(Mandatory=$true)]
   [string]$function)    
switch ($Turn)
{
    'On' {$args = @{args='on'}}
    'Off' {$args = @{args='off'}}
    'Blink' {$args = @{args='blink'}}
    Default {$args = @{args='off'}}
}

$url = "https://api.particle.io/v1/devices/" + $deviceId + "/" + $function + "?access_token=" + $accessToken
write-host $url

Invoke-RestMethod -Method Post -Uri $url -Body $args
}