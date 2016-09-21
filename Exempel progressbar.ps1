$service = Get-Service
$i = 0
$int = $service.Count 


foreach ($item in $service)
{ 
    Write-Host $item
    $i++
    Write-Progress -Activity "List all services" -PercentComplete ($i / $service.Count*100) -Status "$i services out of $int is done"
   
  
}

