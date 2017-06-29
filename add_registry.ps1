
#$adServers = Get-ADComputer -Filter {name -like "srv*" -or name -like "poc*" -or name -like "test*"}

#$adServers | select Name -ExpandProperty name | Out-File -FilePath c:\temp\adcomp.txt -Encoding utf8

$computername = Get-Content C:\temp\adcomp.txt


    $dontExist = @()
    $path = "HKLM:\SYSTEM\CurrentControlSet\services\SNMP\Parameters\PermittedManagers"
    #$cred = Get-Credential
    
    <#

        $script = { if (Test-Path $Using:path)
            {
        New-ItemProperty -Path $Using:path -Name 3 -Value "poc-wupapp01"
                }
                else 
                    {
                         $Global:dontExist+= $env:COMPUTERNAME
                    }
                
                }
         
         #>
            #$script = {Get-ItemProperty $Using:path}
            
            $script = {
                       $testOm3Finns = Get-ItemProperty $using:path

                       if ($testOm3Finns.PSObject.Properties['3']) {write-host "finns på $($env:COMPUTERNAME)"; $testOm3Finns | Select-Object "3"} 
                } #>

        Invoke-Command -ComputerName $computername -ScriptBlock $script -Credential $cred

        $test = Invoke-Command -ComputerName $computername -ScriptBlock $script -Credential $cred



