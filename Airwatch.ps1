Function Set-DeviceListJSON {

	param([array]$deviceIDs)

	# $deviceIDs = @($device01, $device02, $device03)
	$quoteCharacter = [char]34
	$Global:bulkRequestObject = "{ " + $quoteCharacter + "BulkValues" + $quoteCharacter + ":{ " + $quoteCharacter + "Value" + $quoteCharacter + ": ["
	foreach ($deviceID in $deviceIDs) {
		$bulkRequestObject = $bulkRequestObject + $quoteCharacter + $deviceID + $quoteCharacter + ", "
	}
	[int]$stringLength = $bulkRequestObject.Length
	[int]$lengthToLastComma = $stringLength - 2
	$bulkRequestObject = $bulkRequestObject.Substring(0, $lengthToLastComma)
	$bulkRequestObject = $bulkRequestObject + " ] }}"
	Return $bulkRequestObject
   
}

Function Get-BasicUserForAuth {

	Param([string]$userPlusPass)

	
	$encoding = [System.Text.Encoding]::ASCII.GetBytes($userPlusPass)
	$encodedString = [Convert]::ToBase64String($encoding)

	Return "Basic " + $encodedString
}

$header = @{"Authorization" = (Get-BasicUserForAuth ($Username + ":" + $Password)); "aw-tenant-code" = $APIkey; "Accept" = "application/json"; "Content-Type" = "application/json"}




    $hostUrlProd = "https://cn763.awmdm.com/api/mdm/devices/"
    $hostUrlTestDev = "https://cn137.awmdm.com/api/mdm/devices/search"
    $hostUrlTestApp = "https://cn137.awmdm.com/api/mam/apps/search"
    $hostUrlTestSmartGroup = "https://cn137.awmdm.com/api/mdm/smartgroups/107347"
    $hostUrlBulkDevice =  "https://cn137.awmdm.com/api/mdm/devices/id"

    
    <#
    $device01 = "6301"
    $device02 = "6156"
    $device03 = "5966"
    #>

    $Username = "MeetingsAPI"
    $Password = "kallebanan01"
    $APIkey = "YNF9Pz9Frh2C1OKBQEDeEDzojC31sgxalHOa4zTGVXg="
    # Gamla test för att hämta alla devices och apps
    # $webRequestApps = Invoke-WebRequest -Uri $hostUrlTestApp -Headers $header -Method GET
    # $webRequestDevs = Invoke-WebRequest -Uri $hostUrlTestDev -Headers $header -Method GET
    ($webRequestsmartGroups.Content | ConvertFrom-Json).DeviceAdditions


    $webRequestsmartGroups = Invoke-WebRequest -Uri $hostUrlTestSmartGroup -Headers $header -Method GET 
    $bulkDevice = Invoke-WebRequest -Uri $hostUrlBulkDevice -Headers $header -Method Post -Body (Set-DeviceListJSON -deviceIDs (($webRequestsmartGroups.Content | ConvertFrom-Json).deviceAdditions).Id)
    ($bulkDevice.Content | ConvertFrom-Json).Devices



