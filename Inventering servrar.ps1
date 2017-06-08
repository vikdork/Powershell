$global:result = @()

function Get-StaticRoutes {
    param (
        $computername
    )
        
        $scriptBlock = {Get-NetRoute | Where-Object {$_.NextHop -NE "::" -and $_.NextHop -ne "0.0.0.0"}}
        $getRoutes = Invoke-Command -ComputerName $computername -Credential $cred -ScriptBlock $scriptBlock
        $global:routes = [pscustomobject]@{
                computername = $computername
                NextHop = $getRoutes.NextHop
                RouteMetric = $getRoutes.RouteMetric
                DestinationPrefix = $getRoutes.DestinationPrefix
                
            }

}



#$cred = Get-Credential
