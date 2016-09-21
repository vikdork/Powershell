function get-cert 
{

param (
$uri

)

$url = "https:\\"+$uri
$date = Get-Date
$csv ="" | select "Subject","ExpirationDate","Issuer","Format","SerialNumber","DaysUntilExpiration","KeyAlgorithm"
$web = Invoke-RestMethod -Uri $url -Method Get -ErrorAction SilentlyContinue | select statuscode -ErrorAction SilentlyContinue
$request = [System.Net.WebRequest]::Create($Url)

function convertoid([string]$oid) {
 write-debug "In function ConvertToOID: $($oid)"
 #strip off oid component common to all crypto types
 $oidstr = $oid.replace("1.2.840.113549.1.","")
 
 #pull out first number
 $firstval = $oidstr.substring(0,$oidstr.indexof('.'))
 
 #pull out second number for more detail
 $sub = $oidstr.substring(2)
 if ($sub.indexof('.') -gt 0) {
  $sub = $sub.substring(0,$sub.indexof('.')) 
 }
 
 if ($firstval -eq "1") {
  $format = "PKCS-1"
  switch ($sub) {
   "1" { return ($format + " RSA Encryption") }
   "2" { return ($format + " MD2 with RSA") }
   "3" { return ($format + " rsadsi md4 with RSA")}
   "4" { return ($format + " MD5 with RSA") }
   "5" { return ($format + " SHA-1 with RSA") }
   "6" { return ($format + " rsaOAEPEncryptionSet")}
   "11" { return ($format + " sha256 with RSA") }
  }
 } elseif ($firstval -eq "5") {
  $format = "RSA PKCS5"
  switch ($sub) {
   "1" { return ($format + " rsadsi pbe with MD2 DES-CBC")}
   "3" { return ($format + " rsadsi pbe with MD5 DES-CBC")}
   "4" { return ($format + " pbe with MD2 and RC2_CBC")}
   "6" { return ($format + " pbe with MD5 and RC2_CBC")}
   "9" { return ($format + " pbe with MD5 and XOR")}
   "10" { return ($format + " pbe with SHA1 and DES-CBC")}
   "11" { return ($format + " pbe with SHA1 and RC2_CBC")}
   "12" { return ($format + " id-PBKDF2 key derivation function")}
   "13" { return ($format + " id-PBES2  PBES2 encryption")}
   "14" { return ($format + " id-PBMAC1 message auth scheme")}
   
  }
 } elseif ($firstval -eq "7" ) {
  $format = "PKCS-7"
  switch ($sub) {
   "1" { return ($format + " data")}
   "2" { return ($format + " signed data")}
   "3" { return ($format + " enveloped data")}
   "4" { return ($format + " signed and enveloped data")}
   "5" { return ($format + " digested data")}
   "6" { return ($format + " encrypted data")}
  }
 } elseif ($firstval -eq "12") {
  return ("PKCS-12")
 } elseif ($firstval -eq "15") {
  return ("PKCS-15") 
 } else {
  return $oid 
 }
   
 
}




if ($request.ServicePoint.Certificate -eq $null)
{Write-Host It dosn´t exist any certificate on site $url
    
}
else
{
$csv.Subject = $request.ServicePoint.Certificate.subject
$csv.ExpirationDate = $request.ServicePoint.Certificate.GetExpirationDateString()
$csv.Issuer = $request.ServicePoint.Certificate.Issuer
$csv.Format = $request.ServicePoint.Certificate.GetFormat()
$csv.SerialNumber = $request.ServicePoint.Certificate.GetSerialNumberString()
$csv.KeyAlgorithm = convertoid $request.ServicePoint.Certificate.GetKeyAlgorithm()

$time = NEW-TIMESPAN –Start $date –End $csv.ExpirationDate
$csv.DaysUntilExpiration = $time.Days

$csv
}
}


