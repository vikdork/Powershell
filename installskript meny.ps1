do {
    [int]$DMZ = 0

    while ( $DMZ -lt 1 -or $meny -gt 3) {
    write-host "Ska servern vara domänansluten?"
    Write-Host "1. Ja"
    Write-Host "2. Nej"
    Write-Host "3. Avbryt"
   

    [int]$DMZ = Read-Host "Välj 1,2 eller 3"

    switch ($DMZ) {
      1{Write-Host "Kör skript för domänansluten"}
      2{Write-Host "kör skript för icke domänansluten"}
      3{write-host "Avbryt"}
      
    }
  }
  
  }
  until ($DMZ -eq 3)
  
   