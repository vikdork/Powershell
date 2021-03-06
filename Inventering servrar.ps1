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

################################################################################################################################################

$Global:allLocalUsers = @()
<#
.Synopsis
   Get all local users from computers
.DESCRIPTION
   
.EXAMPLE
   Get-LocalAccounts -Computername "srv-hej01", "srv-hej02"
.EXAMPLE
   (get-adcomputer -Filter 'name -like "srv-*"').name | Get-LocalAccounts
#>
function Get-LocalAccounts
{
    [CmdletBinding()]
    
    
    Param
    (
        # Param1 help description
        [parameter(ValueFromPipeline)]
        [String[]]$Computername
    )
      Process  {Write-Host "testar $($Computername)"
        $getAllUsers = Get-WmiObject -Class "Win32_UserAccount" -Filter "LocalAccount='True'" -ComputerName $Computername -Credential $cred
            
            foreach ($user in $getAllUsers) {
                     $Global:allLocalUsers += [pscustomobject]@{
                        computername = $user.PSComputername
                        Name = $User.Name
                        Description = $user.Description
                        
                       
                    }
                    
          
          }
    }
}
#################################################################################################################

               