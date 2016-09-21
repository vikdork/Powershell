$servernamn = "srv-dok01","srv-appli01","srv-appli02","srv-appli03" 
$serv = @()


foreach ($item in $servernamn)
{
try
{
    Write-Host "testar $item"
    Enter-PSSession -ComputerName $item -ErrorAction Stop
    exit-pssession
}
catch 
{
  $serv += $item
}    

}