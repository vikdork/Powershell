#$import = Import-Csv C:\temp\ip.csv


$computers = "huddp2555", "huddp3109", "gri59997"
#$computer = "huddp3109"

$result = @()

foreach ($computer in $import.IP)
{
write-host "Testar $computer"
$owners = @{}
gwmi win32_process -ComputerName $computer |% {$owners[$_.handle] = $_.getowner().user}

$result += get-process -ComputerName $computer | select Machinename, processname,Id,@{l="Owner";e={$owners[$_.id.tostring()]}} | Where-Object processname -eq "OUTLOOK"
}

$result
#$owners = @{}
#gwmi win32_process -ComputerName $computer |% {$owners[$_.handle] = $_.getowner().user}

#get-process -ComputerName $computer | select processname,Id,@{l="Owner";e={$owners[$_.id.tostring()]}} | Where-Object processname -eq "OUTLOOK"
