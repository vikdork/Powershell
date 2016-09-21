
param
([parameter(mandatory)]
[ValidateSet("1way","2way","simultan")]
[string] $Method)
    

$cmd = 'C:\ProgramData\iperf\iperf.exe'
$server1 ='srv-iperf01.adm.huddinge.se'
$computer = '-c'
$2way = '-r'
$simultan = '-d'

switch ($Method)
{
    '1way' {& $cmd $one_way $server1}
    '2way'{& $cmd $one_way $server1 $2way}
    'simultan' {& $cmd $one_way $server1 $simultan}
    }


