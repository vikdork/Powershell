function SR-Play{
 param 
 ([parameter(mandatory)]
 [ValidateSet("P1","P2","P3","P4")]
 [String]$Radiostation)

 $P1 = "http://sverigesradio.se/topsy/direkt/132-hi-mp3.m3u"
 $P2 = "http://sverigesradio.se/topsy/direkt/2562-hi-mp3.m3u"
 $P3 = "http://sverigesradio.se/topsy/direkt/164-hi-mp3.m3u"
 $P4 = "http://sverigesradio.se/topsy/direkt/179-hi-mp3.m3u"
 
$MediaPlayer = New-Object System.Windows.Media.MediaPlayer 

switch ($Radiostation)
{
    "P1" {$MediaPlayer.Open([uri]$p1)}
    "P2" {$MediaPlayer.Open([uri]$p2)}
    "P3" {$MediaPlayer.Open([uri]$p3)}
    "P4" {$MediaPlayer.Open([uri]$p4)}
}
$MediaPlayer.play()
Start-Sleep -Seconds 1

    do {
    [int]$meny = 0

    while ( $meny -lt 1 -or $meny -gt 9) {
    write-host "Kanalmeny, välj kanal eller avsluta."
    Write-Host "1. P1"
    Write-Host "2. P2"
    Write-Host "3. P3"
    Write-Host "4. P4"
    Write-Host "9. Avsluta"

    [int]$meny = Read-Host "Välj en kanal"

    switch ($meny) {
      1{Write-Host "P1"
      $MediaPlayer.Open([uri]$p1)
$MediaPlayer.play()}
      2{Write-Host "p2"
      $MediaPlayer.Open([uri]$p2)
$MediaPlayer.play()}
      3{Write-Host "p3"
      $MediaPlayer.Open([uri]$p3)
$MediaPlayer.play()}
      4{Write-host "p4"
      $MediaPlayer.Open([uri]$p4)
$MediaPlayer.play()}
      9{Write-Host "Hejdå"}
      default {Write-Host "Fel val"}
    }
  }
  
    }
until ("9" -ccontains $meny
)
 if ($meny -eq "9")
    {$MediaPlayer.stop()
    $MediaPlayer.close()
     }
}
SR-Play -Radiostation P3