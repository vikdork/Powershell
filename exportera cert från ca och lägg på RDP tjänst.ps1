

Set-Location -Path cert:\CurrentUser\My
$DNSname = $env:COMPUTERNAME + ".adm.huddinge.se"
$cert = Get-Certificate -Template Machine -DnsName $DNSname  -CertStoreLocation Cert:\LocalMachine\My -Url ldap:
$thumbprint = $cert.Certificate.Thumbprint
$tsgs = gwmi -class "Win32_TSGeneralSetting" -Namespace root\cimv2\terminalservices -Filter "TerminalName='RDP-tcp'"
swmi -path $tsgs.__path -argument @{SSLCertificateSHA1Hash="$thumbprint"}