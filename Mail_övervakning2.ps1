$global:resultDns = @()
$global:IPs = @()


#function to get all MX pointer of a domain or multiple domains
function get-mxpointers
{
    param ([string[]]$urls)
   
        foreach ($url in $urls)
        {
        $global:resultDns += Resolve-DnsName -Name $url -Type MX | Select-Object NameExchange
        }
        
}

$global:IPs = ($ResultDns.nameExchange | Resolve-DnsName).IPAddress 