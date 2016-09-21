cd "d:\build15"

$rss = Invoke-RestMethod -Uri "http://s.ch9.ms/Events/Build/2015/RSS/mp4high"
foreach ($item in $rss)
{
$outfile = $item.title + ".mp4" -replace "[{0},\:,\']", ""
Write-host  ("{0}  -  {1}" -f "Downloadning" ,$item.title)
Start-BitsTransfer $item.enclosure.url -Destination $outfile
   }


