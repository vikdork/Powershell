Install-Module AzureRM
Install-Module Azure -Force

$subscription = "8b01f671-5b88-4577-9b7d-11774ac54ce2"

Login-AzureRmAccount

Get-AzureRmSubscription -SubscriptionId $subscription | select *

$ip = "40.69.220.152"

$serviceNAme = "srv-ham01.northeurope.cloudapp.azure.com"

Enter-PSSession -ComputerName $ip


$uri = Get-AzureWinRMUri -Name srv-ham01

Get-AzurePublishSettingsFile

Import-AzurePublishSettingsFile -PublishSettingsFile 'C:\Users\Viktor\Downloads\Kostnadsfri utvärderingsversion-4-27-2016-credentials.publishsettings'


