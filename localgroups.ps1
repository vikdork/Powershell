function Get-LocalGroupUsers {
    [CmdletBinding()]
    Param
    (
       
        [parameter(ValueFromPipeline)]
        [String[]]$Computername
    )
        process {
            Write-Host "testar $($Computername)"
                    $getAl = Get-WmiObject -Class "Win32_UserAccount" -Filter "LocalAccount='True'" -ComputerName $Computername -Credential $cred

        }
    
    
}


$cred = Get-Credential

$test = Get-WmiObject -Class Win32_GroupUser -Filter "groupcomponent LIKE'HUDDINGE%'"

$computername = "srv-wupapp01"


get-wmiobject -computername $computername -Credential $cred -query "select * from win32_groupuser" | % {$_.GroupComponent; $_.partcomponent}

get-WmiObject -Class Win32_Process -Filter “Name LIKE ‘powershell.e_e'”
