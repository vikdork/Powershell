$outfile = "c:\temp\ping.txt"
$servername = "bufl0310"

while($true)

{
Remove-Variable err
$testnet = Test-Connection $servername -ErrorVariable err -ErrorAction SilentlyContinue
if ($err.count -eq 0)
{write-host "$($servername) Svarar"
}
else
{
$date = get-date
Write-output "$($servername) svarade inte $($date)" | Out-File $outfile -Append
Write-Host "$($servername) svarar inte $($date)"

}
}