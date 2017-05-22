$disk = Get-CimInstance -ClassName win32_LogicalDisk -Filter "DriveType like '3'" | Select @{Name="Drive"; Expression ={$_.DeviceID}}, @{Name="Size in GB"; Expression={[math]::Truncate($_.Size / 1GB)}}, @{Name="Free Space in GB"; Expression={[math]::Truncate($_.FreeSpace / 1GB)}}, PScomputername, @{Name="Free Space percent"; Expression = {[math]::Round($_.FreeSpace / $_.Size * 100,2)}}
$programs = Get-CimInstance -ClassName win32_product| select name, vendor, version, installDate

Get-ChildItem HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Uninstall
