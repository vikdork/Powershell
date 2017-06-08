function Get-StaticRoutes {
    [CmdletBinding()]
    param (
        [parameter(ValueFromPipeline)]
        [string[]]$computername
    )
        $global:routes = @()
        $getRoutes = Get-WmiObject -ClassName "win32_IP4RouteTable" -ComputerName $computername -Credential $cred | Where-Object {$_.NextHop -ne "0.0.0.0"}
         
                foreach ($route in $getRoutes) {
                     $global:routes += [pscustomobject]@{
                        computername = $Route.PSComputername
                        NextHop = $Route.NextHop
                        RouteMetric = $Route.Metric1
                        Destination = $Route.Destination
                        Mask = $Route.Mask
                    }
                    
                }
                $routes
                Remove-Variable route
               }



# $cred = Get-Credential    
# Om man vill lägga in så dest och mask i CIDR.

<#$Mask = $routes.Mask.Split(".")

$val = 0
$mask | foreach-object {$val = $val * 256 + [Convert]::ToInt64($_)}
$ip + "/" + [Convert]::ToString($val,2).IndexOf('0')
#>
################################################################################################################################################



               