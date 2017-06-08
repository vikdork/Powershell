$result = @()

$test = Get-ChildItem

$test.count
    foreach ($item in $test)
    {
    $result += [pscustomobject][ordered] @{
            'Filnamn' =  $item.name
            'mode' = $item.mode 
            'Tjo' = "Hej"
        } 
    }
        $result | Export-Csv -Path c:\temp\test.csv -NoTypeInformation -Encoding UTF8 