##################################################
#Name: get-utfil.ps1
#Aurthor: Viktor Lindström 
#
#
#
#Comments: Downloads Navet Utfil file from skatteverket navet e-transport.
##################################################


#Variabels
$produktidentitet = 'f6178dea-9b7b-feb6-4f14-5b1b7dc969c8'

#URL to check filename
$checkpatpath = "https://shs.skatteverket.se/et/et_web/auto/" + $produktidentitet + "?getfilenames=true"

#get certificate
$certificate = Get-ChildItem -Path cert:\CurrentUser\My | where dnsnamelist -Like "*skatte*"

#Upload to Skatteverket
$Filecheck = Invoke-WebRequest -Uri "$fullpath"  -CertificateThumbprint $certificate.Thumbprint  

#
$getpath = "https://shs.skatteverket.se/et/et_web/auto/" + $produktidentitet + "/" + $Filecheck.Content

$date = get-date -Format d

Invoke-WebRequest -Uri $getpath -CertificateThumbprint $certificate.Thumbprint -OutFile c:\pki\$date.txt 