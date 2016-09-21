$import = Import-Csv C:\temp\konferens\IT_datum.csv -Delimiter ";" -Encoding UTF8

$adjektiven = "Underbara","Rara","Härliga","Trevliga","Fina","Mysiga"
$dagensDatum = get-date
cls
foreach ($item in $import)
{
    $adjektiv = Get-Random -InputObject $adjektiven
    $förnamn = $item.NAMN.Split(",")[1] 
    $efternamn = $item.NAMN.Split(",")[0]
    $datum = get-date $item.ANSTDATUM -Hour 08
    $dagarAnställd = $dagensDatum - $datum
    cls

    write-output  "
 $adjektiv $förnamn $efternamn Började jobba $($datum.DateTime) och har jobbat $($dagarAnställd.Days) dagar, $($dagarAnställd.Hours) timmar och $($dagarAnställd.Minutes) minuter!"
    Start-Sleep -Seconds 10
}