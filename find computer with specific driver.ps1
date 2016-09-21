$computers = Get-Content "C:\temp\datorer.txt"
$date = get-date -Format HH.mm
$outfile1 = "C:\temp\svarar_inte $date.txt"
$outfile2 = "C:\temp\felaktig_drivrutin $date.txt"

foreach ($computer in $computers)
{

Write-Host "testar om $computer svarar"
$connection = Test-Connection $computer -Count 1 -ErrorAction SilentlyContinue
if ($connection -ne $null)
{Write-Host "$computer svarar, kollar om den har felaktig drivrutin."
$exists = Get-PrinterDriver -ComputerName $computer -ErrorAction SilentlyContinue | where driverversion -eq "1970930661982208"

if ($exists -ne $null)
{write-host "$computer har felaktig drivrutin"
out-file -FilePath $outfile2 -Append -InputObject $computer
    
}
else
{write-host "$computer har inte felaktig drivrutin"

}
 
   
}
else
{write-host "$computer svarar inte"
out-file -FilePath $outfile1 -Append -InputObject $computer
}


  }



