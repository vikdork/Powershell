function Get-ClosestSchool
{
    param(
        [String]$Address,
        [String]$Nummer,
        [String]$Postnummer,
        [String]$Postaddress
    )


$schools = Import-Csv C:\Skolor\Skolor.csv -Delimiter ";"
$result = @()
$Global:key = "AIzaSyDRCGfJmQl2kWG7yAX6svxpRGFDsw4OtRE"
$mode = "walking"

foreach ($school in $schools)
    {
    
    $url = "https://maps.googleapis.com/maps/api/distancematrix/json?origins=" + $Address +"+" +$Nummer + "+" + $Postnummer + "+" + $Postaddress + "&destinations=" + $school.Address + "+" + $school.nummer + "+" + $school.postnummer + "+" + $school.Postaddress + "&mode=" + $mode + "&key=" + $key
    $googleDistance = Invoke-RestMethod -Uri $url
   

    $result += New-Object PSObject -Property @{
        Gymnasium = $school.Skola
        Address = $school.Address
        Nummer = $school.nummer
        Postnummer = $school.postnummer
        Postaddress = $school.Postaddress
        Distans = $googleDistance.rows.elements.distance.value
        DistansKM = $googleDistance.rows.elements.distance.text
    
    }
    }


    $closest = ($result | Sort-Object Distans)[0]
    $closest
}
   
      Get-ClosestSchool -Address korphoppsgatan -Nummer 3 -Postnummer 12064 -Postaddress Stockholm  
        #$result
    
    #write-host "$($closest.Gymnasium) ligger närmst, det är $($closest.DistansKM) gångväg från $($orginAddress) i $($orginPostAddress)"

    <#
$orginAddress = "korphoppsgatan"
$orginNummer =  "3" 
$orginPostNummer = "12064" 
$orginPostAddress = "Stockholm"
#>



