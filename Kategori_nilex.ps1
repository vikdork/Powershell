$importKategoriNilex = Import-Csv 'C:\temp\Kategorier Nilex .csv' -Delimiter ";"
$importTjänter = Import-Csv C:\temp\Kategori_tjänstekatalog.csv -Delimiter ";" 

$resultat = @()


foreach ($kategoriNamn in $importKategoriNilex)
{
$tempResult = New-Object System.Object

switch ($kategoriNamn.LEVEL_)
{
    '0' {$tempResult | Add-Member -type NoteProperty -name Level0 -Value $kategoriNamn.NAme_
         $tempResult | Add-Member -type NoteProperty -name Level1 -Value ""   
         $tempResult | Add-Member -type NoteProperty -name Level2 -Value ""}
    '1'  {$tempResult | Add-Member -type NoteProperty -name Level0 -Value ($importKategoriNilex | Where-Object ID -eq $kategorinamn.PARENT_ID).NAME_
         $tempResult | Add-Member -type NoteProperty -name Level1 -Value $kategoriNamn.NAme_
         $tempResult | Add-Member -type NoteProperty -name Level2 -Value ""}
    '2' {$tempResult | Add-Member -type NoteProperty -name Level2 -Value $kategoriNamn.Name_
         $tempResult | Add-Member -type NoteProperty -name Level1 -Value ($importKategoriNilex | Where-Object ID -eq $kategorinamn.PARENT_ID).NAME_
         $parent = $importKategoriNilex | Where-Object ID -eq $kategorinamn.PARENT_ID | Select-Object ID
         $parent2 = $importKategoriNilex | Where-Object {$parent.id -eq $_.ID}
         $tempResult | Add-Member -type NoteProperty -name Level0 -Value ($parent2).PARENT_NAME}
    
    }
    if ($tempResult.level0)
    {
        $resultat += $tempResult
    }
    
    
    


}
    
$resultat




