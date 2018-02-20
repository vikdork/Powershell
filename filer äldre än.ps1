$date = (Get-Date).AddMonths(-24)
$allFiles = Get-ChildItem -Recurse | Where-Object {$_.lastwritetime -lt $date -and -not $_.PsIsContainer} | Measure-Object -Property Length -Sum

$result = [psobject] @{
    "Antal filer" = $allFiles.count
    "Storlek GB" = $allFiles.Sum / 1GB
    }

$result

