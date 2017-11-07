#$cred = Get-Credential

$comp = Get-ADComputer -Filter 'name -like "*test-*" -or Name -like "*poc-*" -or Name -like "*srv-*"'

#param ([parameter(Mandatory=$true)]$comp)
$cimsession =  new-cimsession -ComputerName $comp.name -Credential $cred

$os = Get-Ciminstance Win32_OperatingSystem -CimSession $cimsession -Property *

$lista = $os | Select PSComputerName, @{Name = "Procent_Fritt"; Expression = {[math]::Round(($_.FreePhysicalMemory/$_.TotalVisibleMemorySize)*100,2)}},
@{Name = "FreeGB";Expression = {[math]::Round($_.FreePhysicalMemory/1mb,2)}},
@{Name = "TotalGB";Expression = {[int]($_.TotalVisibleMemorySize/1mb)}} | Sort-Object Procent_Fritt -Descending



