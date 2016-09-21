function calc-toMbitMonth 
{
param (
[int]$gb
)
$seconds = 2592000

$gbToMb = $gb * 1024
$result = ($gbToMb / $seconds * 8).ToString("#")
Write-Host "$result mbits/sec"

}

