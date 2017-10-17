

 param (
        [Parameter(Mandatory=$true)]
        [string]$parcelId
        
        )    
        $result = @()
        $url = "http://privpakportal.schenker.nu/TrackAndTrace/packagexml.aspx?packageid=" + $parcelId
            $getParcelinfoDBSchenker = Invoke-WebRequest -Uri $url 
                $events = ([xml]$getParcelinfoDBSchenker.Content.Trim("ï»¿")).pactrack.body.parcel.event
                    $result += [pscustomobject]@{
                        "Utlämningsställe" = ([xml]$getParcelinfoDBSchenker.Content.Trim("ï»¿")).pactrack.body.parcel.ppc_name
                        "Händelser" = $events
                        "Vikt" = ([xml]$getParcelinfoDBSchenker.Content.Trim("ï»¿")).pactrack.body.parcel.actualweight
                        "Löpnummer" = ([xml]$getParcelinfoDBSchenker.Content.Trim("ï»¿")).pactrack.body.parcel.ppc_lopnr

                        
                                               }
                                               #$result
                                               $result.Händelser  
                                               $result | Select-Object Utlämningsställe, Vikt, Löpnummer             
                    