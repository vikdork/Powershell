# Få ut samtliga mappar där det krypterats
$file = "HUR_DEKRYPTERA_FILER.txt"
$folders = Get-ChildItem -Recurse -Filter $file | select directory
$files = @()
#  Få ut alla filer från mapparna.

# Läsa ut filer som ligger i varje mapp som blivit påverkad
foreach ($filepath in $folders)
{
    $files += Get-ChildItem -Path $filepath.directory -File
    write-host "läser ut filer för mapp $($filepath.Directory)"
}

# Exportera foldrar och filer som tas bort glöm ej ändra path
$files.fullname | out-file "c:\temp\srv-appli05_Z_Filer.txt" -Encoding UTF8
$folders | Out-File "c:\temp\srv-appli05_Z_foldrar.txt" -Encoding utf8



#$files | Remove-Item