# Importera jokercertet i local computer personal certifikat. Kör raderna en efter en oc kontrollera så variablerna fylls med rätt information Thump ska ha thumpirnt som motsvarar thumprint på jokercertet.

$tsgs = gwmi -class "Win32_TSGeneralSetting" -Namespace root\cimv2\terminalservices -Filter "TerminalName='RDP-tcp'"
$thumb = (gci -path cert:/LocalMachine/My | Where-Object Subject -like "*tekniker*").Thumbprint
swmi -path $tsgs.__path -argument @{SSLCertificateSHA1Hash="$thumb"}