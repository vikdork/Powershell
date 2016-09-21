function calc-toMbit 
{
param (
[int]$gb
)
$seconds = 86400

$gbToMb = $gb * 1024
$result = ($gbToMb / $seconds * 8).ToString("#")
Write-Host "$result mbits/sec"

}
