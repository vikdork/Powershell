#File variables
$sourcefile = "C:\Pki\navet_1501690.0"
$workfile = "C:\pki\workfile.txt"
$resultfile = "C:\pki\resultat.txt"

#Filter working posts
$content = Get-Content $sourcefile -Encoding UTF7
$content | Select-String "#UP 01001", "#UP 01012", "#UP 01014", "#UP 01011", "#UP 01013"  | Set-Content $workfile -Encoding UTF8

#Wash away unwanted data and replace space between code and value with comma.
$content2 = Get-Content $workfile -Encoding UTF8
$content2 | foreach {$_ -replace "#UP 01001 ", "01001,"} | set-content $workfile -Encoding UTF8
$content2 = Get-Content $workfile -Encoding UTF8
$content2 | foreach {$_ -replace "#UP 01014 ", "01014,"} | set-content $workfile -Encoding UTF8
$content2 = Get-Content $workfile -Encoding UTF8
$content2 | foreach {$_ -replace "#UP 01012 ", "01012,"} | set-content $workfile -Encoding UTF8
$content2 = Get-Content $workfile -Encoding UTF8
$content2 | foreach {$_ -replace "#UP 01011 ", "01011,"} | set-content $workfile -Encoding UTF8
$content2 = Get-Content $workfile -Encoding UTF8
$content2 | foreach {$_ -replace "#UP 01013 ", "01013,"} | set-content $workfile -Encoding UTF8


# Create CSV with headers.
$import = Import-Csv $workfile -Encoding UTF8 -Delimiter "," -Header Code, Value

#
$row = "" | select "Personnummer","Tilltalsnamnsmarkering", "Förnamn", "Mellannamn", "Efternamn"

#Delete resultfile if it exists.
if (test-path $resultfile)
{Remove-Item -Path $resultfile
    
}

foreach ($item in $import)
  { switch ($item.Code) {
    "01001" {$row.Personnummer = $item.value}
    "01011" {$row.Tilltalsnamnsmarkering = $item.value}
    "01012" {$row.förnamn = $item.value}
    "01013" {$row.Mellannamn = $item.value}
    "01014" {$row.Efternamn = $item.value}
    }
    
                      
        if ($row.Personnummer -ne $null -And $row.Förnamn -ne $null -and $row.Efternamn -ne $null)
                { 
              
                $row | export-csv $resultfile  -Append -NoTypeInformation -Encoding UTF8 
                $row.personnummer = $null
                $row.förnamn = $null
                $row.efternamn = $null
                $row.Tilltalsnamnsmarkering = $null
                $row.Mellannamn = $null
                
                    
                    
                               }

                               }
                                











