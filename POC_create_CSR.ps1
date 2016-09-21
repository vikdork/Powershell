# Skapa CSR huddinge standard
function MyFunction 
{
param (
[Parameter(Mandatory=$true)]
[string]$commonname
)
$openSslExe = "C:\OpenSSL-Win32\bin\openssl.exe"
$subject = "/C=SE/ST=Stockholm/L=Huddinge/O=Huddinge kommun/CN=" + $commonname
$csr = "c:\temp\" + $commonname + ".csr"
$key = "c:\temp\" + $commonname + ".key"
$arg = 'req', '-new', '-newkey', 'rsa:2048', '-nodes', '-out', $csr,  '-keyout', $key, '-subj', $subject
#& $openSslExe req -new -newkey rsa:2048 -nodes -out $csr -keyout $key -subj $subject
& $openSslExe $arg
    
}


