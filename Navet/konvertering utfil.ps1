##################################################
#Name: Konvertering utfil.ps1
#Aurthor: Viktor Lindström 
#
#
#
#Comments: Converts Navet Utfil-file to Heroma compatible file
#Rev1.01(2015-01-15 Added Code 01003 because of secrecy
#Rev1.02(2015-01-15 replaced out-file to set-content to have ANSI encodeing. Line 79
##################################################

#File variables
$date = get-date -Format d

$sourcefile = "C:\pki\" + $date + ".txt"
$workfile = "C:\pki\workfile.txt"
$resultfile = "C:\pki\resultat.txt"
$heromafile = "C:\pki\heroma.txt"

#Filter working posts
$content = Get-Content $sourcefile -Encoding UTF7
$content | Select-String "#UP 01001","#UP 01002", "#UP 01012", "#UP 01014", "#UP 01011", "#UP 01013","#UP 01003"  | Set-Content $workfile -Encoding UTF8

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
$content2 = Get-Content $workfile -Encoding UTF8
$content2 | foreach {$_ -replace "#UP 01003 ", "01003,"} | set-content $workfile -Encoding UTF8
$content2 = Get-Content $workfile -Encoding UTF8
$content2 | foreach {$_ -replace "#UP 01002 ", "01002,"} | set-content $workfile -Encoding UTF8


# Create CSV with headers.
$import = Import-Csv $workfile -Encoding UTF8 -Delimiter "," -Header Code, Value

#
$row = "" | select "Personnummer","Tilltalsnamnsmarkering", "Förnamn", "Mellannamn", "Efternamn","Fullständigt namn","C/O adress","Utdelningsadress 1","Utdelningsadress 2","Postnummer","Postort","Anonym"

#Delete resultfile if it exists.
if (test-path $resultfile)
{Remove-Item -Path $resultfile
    
}

foreach ($item in $import)
  { switch ($item.Code) {
    "01001" {$row.Personnummer = $item.value}
    "01002" {$row.Personnummer = $item.value}
    "01003" {$row.Anonym = $item.value}
    "01011" {$row.Tilltalsnamnsmarkering = $item.value}
    "01012" {$row.förnamn = $item.value}
    "01013" {$row.Mellannamn = $item.value}
    "01014" {$row.Efternamn = $item.value}

   }
    
                      
        if ($row.Personnummer -ne $null -And $row.Förnamn -ne $null -and $row.Efternamn -ne $null)
                { 
              
                $row | export-csv $resultfile  -Append -NoTypeInformation -Encoding UTF8 -Delimiter ";"
                $row.personnummer = $null
                $row.förnamn = $null
                $row.efternamn = $null
                $row.Tilltalsnamnsmarkering = $null
                $row.Mellannamn = $null
                $row.Anonym = $null
                
                    
                    
                               }

                               }
                               

#Remove qotations marks and delete headlines and convert to ANSI
                               Get-content $resultfile | % {$_ -replace '"', ""} | select -Skip 1| set-content $heromafile
                                











