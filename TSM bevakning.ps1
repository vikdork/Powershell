$cmd = 'C:\Program Files\Tivoli\TSM\baclient\dsmadmc.exe'
$parameters = '-tcpserveraddress=SRV-TIVOLI01', '-tcpport=1500', '-id=admvili', '-password=N0pl1sss', 'q', 'pr'
$path = 'C:\temp'
cd $path



$test = & $cmd $parameters
$test

$resultat = $test | select-string "Backup Storage Pool"

switch ($resultat.Count)
{
    '1' {write-host "En går"}
    '2' {Write-Host "Båda går"}
    '0' {Write-host "ingen går"}
}