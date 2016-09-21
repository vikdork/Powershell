

$global:resultDns = @()
$global:IPs = @()
#function to get all MX pointer of a domain or multiple domains
function get-mxpointers
{
    param ([string[]]$urls)
   $global:resultDns = @()
        foreach ($url in $urls)
        {
        $global:resultDns += Resolve-DnsName -Name $url -Type MX | Select-Object NameExchange
        }
        $global:IPs = ($ResultDns.nameExchange | Resolve-DnsName).IPAddress
}



function my-sederscore {



param ([string[]]$ipAddresses)
$result = ""
$result = @()
  
   foreach ($ip in $ipAddresses)
   {
      $split = $ip.Split(".")
      $reverseIp = $split[3]+"."+$split[2]+"."+$split[1]+"."+$split[0]
      $senderScoreName = $reverseIp + ".score.senderscore.com"
      $resolveIP =   Resolve-DnsName $senderScoreName -Server 8.8.8.8
      $hostName = Resolve-DnsName -Name $ip


      $result += New-Object psobject -Property @{
               
                      Score = $resolveIP.Address.Split(".")[3]
                      IP  = "$ip"
                      HostName = $hostName[0].NameHost.ToString()
                     }

       
   }

$result
   
}

function get-score  
{
    param ([string[]]$domains)
 get-mxpointers -urls $domains
 my-sederscore -ipAddresses $IPs   
}

get-score -domains huddinge.se



