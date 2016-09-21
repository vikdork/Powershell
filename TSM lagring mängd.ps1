# Måste köras som admin
Set-Location -Path "\Program Files\Tivoli\TSM\baclient"
$test = .\dsmadmc.exe -id=admvili -password=Sommar2016 Query STGpool | select -skip 16 | select -First 5 | ConvertFrom-String  | Where-Object {$_.P1 -eq "BACKUPPOOL" -or $_.P1 -eq "COPYPOOL"} 
$result = @()

foreach ($item in $test)
{
    $sizeInGb = $item.p4.ToString() + $item.p5.ToString()
    [int]$sizeInGbInt = $sizeInGb 

    
    
    $result += New-Object psobject -Property @{
                                    'Pool' = $item.P1
                                    'SizeInGB' = $sizeInGb
                                    'PercentUtilization' = ($item.p7/1000)*100
                                    'GBUtilization' = $sizeInGbInt * ($item.p7/1000)
                                    'GBsFree' = $sizeInGbInt - ($sizeInGbInt * ($item.p7/1000))
                                    'Date' = get-date -Format d
                                    }
                                   
}
$result