#$credNas = Get-Credential

$databases = "Certificate"
$server = "test-viktor01"
$backupLocation = "\\nas-sabac01\Backup_Active"
$backupDrive = "Q"
$date = get-date -Format yyyyMMdd
$backupFileName = $date + ".bak"
$localBackup = "c:\temp\" + $backupFileName

New-PSDrive -Name $backupDrive -PSProvider FileSystem -Root $backupLocation -Credential $credNas

Backup-SqlDatabase -ServerInstance $server -Database $databases -BackupFile $localBackup -CompressionOption On -EncryptionOption 