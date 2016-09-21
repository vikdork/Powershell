# Man behöver lägga in ESPIPSToolkit på servern som ska köra det här.
$user = @{"Username"="emcstats";"Password"="HZr9h5Ubx4VLCgJj7Pce";"SpaIpAddress"="172.16.10.179";"SpbIpAddress"="172.16.10.180"; "UserFriendlyName"="VNX-x"};
connect-emcsystem -SystemType "vnx-block" -CreationParameters $user
Get-EmcStoragePool data* | Select-Object TotalCapacity, AvailableCapacity, SubscribedCapacity