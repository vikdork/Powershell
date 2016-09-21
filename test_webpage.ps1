$import = Import-Csv C:\temp\websidor2.csv -Delimiter ";" -Encoding UTF8


$exists = @()
$notExists = @()

foreach ($item in $import)
{
    
    try
    { Write-Host "testar $($item.name)"
      if (Invoke-WebRequest -Uri $item.name -ErrorAction Stop)
      {
      $exists += New-Object psobject -Property @{
      "type" = $item.type
      "Name" = $item.name
      "Data" = $item.data
      }
      
      }
    }
    catch 
    {
        $notExists += $item.name
    }
    

}




