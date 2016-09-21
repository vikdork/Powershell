while($true)

{

$date = get-date
Remove-Variable err
$testnet = Test-Connection 126.5.0.30 -ErrorVariable err -ErrorAction SilentlyContinue
if ($err.Count -eq 0)
{write-host "svarar"

    
}
else
{
    Write-Host "DNS svarar inte"
    get-date
    Write-Output "$($date)" | Out-File c:\temp\dns.txt -Append

}
}