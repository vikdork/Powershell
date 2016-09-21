# Create secure string password
#read-host -assecurestring | convertfrom-securestring | out-file C:\temp\cred.txt

# Import secure string password
$password = get-content C:\temp\cred.txt | convertto-securestring
$credentials = new-object -typename System.Management.Automation.PSCredential -argumentlist "srv-saweb01\sys_cm01",$password

# Variables
$crlPath = "c:\crl"
$drive = "K:\"
$crlWebbPath = "\\srv-saweb01\cdp"
$crlHuddingeKommunRootCAv1PP = "HuddingeKommunRootCAv1PP.crl.old"
$crlSmartKortCAv1PP = "SmartKortCAv1PP.crl.old"
$crlHuddingeKommunRootCAv1AP = "HuddingeKommunRootCAv1AP.crl.old"
$crlSmartKortCAv1AP = "SmartKortCAv1AP.crl.old"
$rawCrl = "crll-6028479628037215904*.crl", "crll-5335970211394363039*.crl", "crll-774599739530832992*.crl", "crll-4235019390437043400*.crl"

# Mapp network drive 
New-PSDrive -Name K -PSProvider FileSystem -Root $crlWebbPath -Credential $credentials

# Get latest crl files and set copy path and destination path.
foreach ($crll in $rawCrl)
    {
    
    if ($newestCrlFile) {Clear-Variable newestCrlFile}
    $newestCrlFile = (Get-ChildItem -Path $crlPath -Filter $crll | Sort-Object LastWriteTime -Descending).FullName
    if ($newestCrlFile) 
    {$copyPath = $newestCrlFile[0]
     # Set destination path
     switch ($copyPath)
     {
         {$_ -like "*6028479628037215904*" } {$destination = $drive + $crlHuddingeKommunRootCAv1PP}
         {$_ -like "*5335970211394363039*" } {$destination = $drive + $crlSmartKortCAv1PP}
         {$_ -like "*774599739530832992*" } {$destination = $drive + $crlHuddingeKommunRootCAv1AP}
         {$_ -like "*4235019390437043400*" } {$destination = $drive + $crlSmartKortCAv1AP}
     }
            # Transfer files
            Copy-Item -Path $copyPath -Destination $destination
}
}

# Remove Crls
Get-ChildItem -Path $crlPath | Remove-item
Remove-PSDrive -Name K -Force


