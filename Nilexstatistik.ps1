
# Import
$import = Import-Csv C:\test\Nilex_rap20170301.csv -Encoding UTF8 -Delimiter ";"
$2016 = $import | Where-Object "Stängt datum" -Like "2017-02*"

#Plocka ut kategorier
$kategorier = ($2016 | Sort-Object -Unique kategori).kategori

# deklarera resultatvariabel
$resultat = @()

# PLocka ut data och gör om
foreach ($item in $kategorier)
{
    $countsummin = ($2016 | Where-Object kategori -Like $item).'Summa tid (min)' | measure-object -Sum
    $countsumtim = ($2016 | Where-Object kategori -Like $item).'Summa tid (tim)' | measure-object -Sum
    $timtillmin = ($countsumtim.sum * 60) + $countsummin.sum
    $totaltime = [timespan]::FromMinutes($timtillmin)
    $resultat += New-Object psobject -Property @{
            
            Kategroi = $item
           'Antal ärenden' = $countsummin.Count
           'Antal timmar' = "{0:N0}" -f $totaltime.TotalHours
           'Snitt minuter per ärende' = [int][Math]::Ceiling($totaltime.TotalMinutes / $countsummin.count)
            
            
           
            
            }
         $countsummin = ""
            $countsumtim = ""
    }
        
# Export
    $resultat | Sort-Object 'antal timmar' -Descending | Export-Csv c:\temp\2017_01_utvärdering2.csv -Encoding UTF8 -NoTypeInformation -Delimiter ";"