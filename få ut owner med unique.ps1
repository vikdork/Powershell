# Få ut vilka som har skapat txt filerna lika med vem som varit påverkad av cryptovirus
$file = "HUR_DEKRYPTERA_FILER.txt"
$owners = Get-ChildItem -Recurse -Filter $file | Get-Acl | select owner
$owners.owner | Sort-Object -Unique