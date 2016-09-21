##################################################
#Name: Push_infil.ps1
#Aurthor: Viktor Lindström 
#
#
#
#Comments: Uploads Navet Infil file to skatteverket navet e-transport.
##################################################

#Variabels
$produktidentitet = "f6178dea-9b7b-feb6-4f14-5b1b7dc969c8"
$infil = "C:\pki\datafil.txt"

#get certificate
$certificate = Get-ChildItem -Path cert:\CurrentUser\My | where dnsnamelist -Like "*skatte*"

#Upload to Skatteverket
Invoke-WebRequest -Uri "https://shs.skatteverket.se/et/et_web/auto/$produktidentitet" -CertificateThumbprint $certificate.Thumbprint -Method Post -InFile $infil 




