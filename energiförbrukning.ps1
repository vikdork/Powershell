
#variables
$script:watt 
$script:kwh
$script:prisÖreKwh
$script:kwd
$script:kwm
$script:kwy
$consumption = ""
$consumption = @()




<#
I choosen to remove this function since it misses the fixed costs from the electric companies
#function to collect current spotprice for SE3(svealand) from Nordpool. Where-object collects from 12:00 a clock.
function get-kwPrice
{

#schablom spotpåslag
$spotPåSlag = 3
$energiskatt = 29.4
$elNätsAvgift = 44.2


try
{
  $web = Invoke-WebRequest "http://datafeed.expektra.se/datafeed.svc/spotprice?bidding_area=se3" -ErrorAction Stop
  $spotPrice = (($web.Content | ConvertFrom-Json).data | Where-Object utc -like "*T12*" | Select-Object value).value / 10
}
catch 
{
    Write-Host "Kunde inte hämta data för spotpris använder schablonsifran 23 öre"
    $spotPrice = "23"
}
($spotPåSlag + $energiskatt + $spotPrice) * 1.25 + $elNätsAvgift
}

#>


#function to calculate watt from volt and amp
function calculate-watt
{
param (
[Parameter(mandatory=$true)]
[decimal]$volts,

[Parameter(mandatory=$true)]
[decimal]$amps
)
$script:watt = $volts * $amps
    }


#function to calculate kwh, kwd, kwm and kwy.
function calculate-kw
{
 param (   
    [parameter(mandatory=$true)]
    [int]$watts        
    )

    $script:kwh = $watts / 1000
    $script:kwd = $script:kwh * 24
    $script:kwm = $script:kwd * 30
    $script:kwy = $script:kwd * 365
}

#Main function
function calculate-KwPrice
{
param (
        [double]$yearlyConsumption = 3815,
        [double]$yearlycost = 4884,
        [double]$volt,
        [double]$ampere,
        [double]$watt
        )
                if ($watt -gt 0)
                {
                $prisÖreKwh = $yearlycost / $yearlyConsumption *100
                calculate-kw -watts $watt 
                $consumption += New-Object psobject -Property @{

               
                      "Kostnad per timme" = ($kwh * $prisÖreKwh).ToString("#.##") +" öre"
                      "Kostnad per Dag"  = ($kwd * $prisÖreKwh).ToString("#.##") + " öre"
                      "Kostnad per Månad"  = ($kwm * $prisÖreKwh / 100).ToString("#.##") +" Kr"
                      "Kostnad per År"  = ($kwy * $prisÖreKwh / 100).ToString("#.##") + " Kr"
                      }     
              $consumption
                }
            else
            {
            $prisÖreKwh = $yearlycost / $yearlyConsumption * 100
            calculate-watt -volts $volt -amps $ampere
            calculate-kw -watts $script:watt
            $consumption += New-Object psobject -Property @{
               
                      "Kostnad per timme" = ($kwh * $prisÖreKwh).ToString("#.##") +" öre"
                      "Kostnad per Dag"  = ($kwd * $prisÖreKwh).ToString("#.##") + " öre"
                      "Kostnad per Månad"  = ($kwm * $prisÖreKwh / 100).ToString("#.##") +" Kr"
                      "Kostnad per År"  = ($kwy * $prisÖreKwh / 100).ToString("#.##") + " Kr"
             }

$consumption
}

}





