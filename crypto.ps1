
# Få ut samtliga mappar där det krypterats
$file = "HUR_DEKRYPTERA_FILER.txt"
$folders = Get-ChildItem -Recurse -Filter $file | select directory

#  Få ut alla filer från mapparna.

# Läsa ut filer som ligger i varje mapp som blivit påverkad
foreach ($filepath in $folders)
{
    $files += Get-ChildItem -Path $filepath.directory
    write-host "läser ut filer för mapp $($filepath.Directory)"
}




#$files.fullname | Export-Csv -Path c:\temp\gemensam_hela.txt -NoTypeInformation -Encoding UTF8