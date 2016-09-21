$userCredentials = Get-Credential

$session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://srv-exch03/powershell -Authentication Kerberos -Credential $userCredentials

Import-PSSession $session