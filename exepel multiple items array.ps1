$VMarray = ""
$VMarray = @()

$VMarray += New-Object psobject -Property @{
               
                      VmName = [string]"srv-test01"
                      VMIso  = [string]"finns ingen"
                      VMPath = [string]"C:\hej"
                      VMMemory = [int]4
                      VMDisk   = [int]40
                      VMSwitch = [string]"intern"
                      }