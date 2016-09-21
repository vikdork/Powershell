Import-Module Sqlps -DisableName
$insert_stmt = "INSERT INTO [Certificate].[dbo].[host] (Host,IP,Application) VALUES ('hej','tjo','man')" 


$test = Invoke-Sqlcmd  -ServerInstance “test-viktor01” -Query “Select * FROM certificate.dbo.host”


Invoke-Sqlcmd  -ServerInstance “test-viktor01” -Query $insert_stmt