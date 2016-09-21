
#Global variables
[double]$result=""
$computerarray = @()
[int]$total = ""

#Array of computers
$servers1 = Get-ADComputer -Filter * -SearchBase "OU=Servers,DC=adm,DC=huddinge,DC=se"
$servers2 = Get-ADComputer -Filter * -SearchBase "OU=Server,OU=Data,DC=adm,DC=huddinge,DC=se"
$DCs = Get-ADComputer -Filter * -SearchBase  "OU=Domain Controllers,DC=adm,DC=huddinge,DC=se"

$computers = $servers1 + $servers2 + $DCs


#function to collect all eventlogs and check max size and fill 
function get-logs 

{ 
param( $computer = $env:COMPUTERNAME
)


$logs = Get-EventLog -ComputerName $computer -LogName * | select *

[int]$Mbytes = ""

foreach ($log in $logs)
{$Mbytes += $log.maximumkilobytes
    
}
$global:result = $Mbytes * 1024 /1MB
$global:total += $result

$script:computerarray += New-Object psobject -Property @{
               
                      Datornamn = $computer
                      Loggar_i_MB = $result -as [int]
                      }
                      }


# Use function get-logs on all computers in array.
foreach ($computer in $computers.name)
{
   Write-Host "kollar $computer"
   get-logs -computer $computer
   #$computer.name
}


# Add total size to result array.
$script:computerarray += New-Object psobject -Property @{
               
                      Datornamn = "Total"
                      Loggar_i_MB = $total
                      }

# Export to CSV
$title = "Exportera till CSV"
$message = "Vill du exportera reslutatet till en CSV fil(C:\temp\comp.csv)?"

$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Ja"

$no = New-Object System.Management.Automation.Host.ChoiceDescription "&Nej"

$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)

$result = $host.ui.PromptForChoice($title, $message, $options, 0) 

switch ($result)
    {
        0 {$computerarray | select Datornamn, Loggar_i_MB | Export-Csv C:\temp\comp.csv -NoTypeInformation}
        1 {"OK, allt är klart"}
    }                      

