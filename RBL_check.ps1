
function Check-RBL 
{
  [cmdletbinding()]
param ([Parameter(Mandatory=$true)]
      [string[]]$IPaddresses

        )
       # Get a list of active Black lists from www.dnsbl.info
       $getDnsblList = (Invoke-WebRequest -Uri "http://www.dnsbl.info/dnsbl-list.php").links | Where-Object {$_.href -like "*/dnsbl-details.php?*"} | Select-Object innerHTML
       $reverseIps = @()
       $resultRbl = @()
       $onLists = @()

       #get a reverse on IP-addresses
         foreach ($ip in $IPaddresses)
         {
         $split = $ip.Split(".")
         $reverseIps += $split[3]+"."+$split[2]+"."+$split[1]+"."+$split[0]
         Write-host reverseip är $reverseIps
         }

            foreach ($item in $getDnsblList.innerHTML)
            {
                foreach ($reverseIp in $reverseIps)
                {   $url = "$reverseIp" +"." + "$item"
                    
                    
                    $onLists += Resolve-DnsName $url -ErrorAction SilentlyContinue
                    }
            
            
            }
            $onlists | Sort-Object name -Unique
            $reverseIps = ""
            $onLists = ""
   }



  

   

