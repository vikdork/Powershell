function get-rssfeed
{

param(
[switch]$Export_CSV,
[string]$Filepath,
[parameter(mandatory=$true)]
[string]$url
)
$rss = Invoke-RestMethod -Uri $url

    if ($Export_CSV -eq $true)
     {
   
      if ($filepath.Length -lt 3)
        {
        $rss | Select-Object title, link | Export-Csv C:\Temp\rss.csv -NoTypeInformation
        Write-Host "RSS-feed vas exported to C:\Temp\rss.csv" -ForegroundColor Yellow
        $rss | Select-Object title, link
        }
         else
          {
           $rss | Select-Object title, link | Export-Csv $filepath -NoTypeInformation
           Write-Host "RSS-feed vas exported to $filepath" -ForegroundColor Yellow
           $rss | Select-Object title, link
          }
       }
     else
    {
      $rss | Select-Object title, link
    }
   }
