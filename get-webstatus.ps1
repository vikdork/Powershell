#Result-variables

$import = @(Import-Csv C:\temp\websidor2.csv -Delimiter ";" -Encoding UTF8)

$activeWebs = @()
$global:inactiveWebs = @()

    function Get-WebStatus {
        param (
        [string[]]$url
        )
        
           foreach ($item in $url)
           {
                    try
               {
                 
                  $workUri = $item | ConvertFrom-String -PropertyNames Type, Name, Data -Delimiter ";"
                  write-host "testar $($workUri.Name.Replace('Name=', '').trim())"
                   $test = Invoke-WebRequest -Uri ($workUri.Name.Replace("Name=", "").trim()) -ErrorAction Stop
                   $global:activeWebs += New-Object psobject -Property @{
                                        "Type" = $workUri.Type.Replace("@{Type=", "").trim()
                                        "Name" = $workUri.Name.Replace("Name=", "").trim()
                                        "Data" = $workUri.Data.Replace("Data=", "").trim() -replace "}", ""
      }
               }
               catch 
               {
                 

                 $global:inactiveWebs += New-Object psobject -Property @{
                                        "Type" = $workUri.Type.Replace("@{Type=", "").trim()
                                        "Name" = $workUri.Name.Replace("Name=", "").trim()
                                        "Data" = $workUri.Data.Replace("Data=", "").trim() -replace "}", ""
               }
           }
       }
       }
      