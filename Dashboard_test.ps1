if ($i -eq $null){$i = 8080}
$i++

$Colors = @{
    BackgroundColor = "#FF252525"
    FontColor = "#FFFFFFFF"
}

$NavBarLinks = @((New-UDLink -Text "<i class='material-icons' style='display:inline;padding-right:5px'>favorite_border</i> PowerShell Pro Tools" -Url "https://poshtools.com/buy-powershell-pro-tools/"),
                 (New-UDLink -Text "<i class='material-icons' style='display:inline;padding-right:5px'>description</i> Documentation" -Url "https://adamdriscoll.gitbooks.io/powershell-tools-documentation/content/powershell-pro-tools-documentation/about-universal-dashboard.html"))

$servers = Get-ADComputer -Filter 'name -like "*test-*" -or Name -like "*poc-*" -or Name -like "*srv-*"' -Properties OperatingSystem
Start-UDDashboard -port $i -Content { 
    New-UDDashboard -NavbarLinks $NavBarLinks -Title "PowerShell Pro Tools Universal Dashboard" -NavBarColor '#FF1c1c1c' -NavBarFontColor "#FF55b3ff" -BackgroundColor "#FF333333" -FontColor "#FFFFFFF" -Content { 
        New-UDRow {
            New-UDColumn -Size 3 {
                New-UDHtml -Markup "<div class='card' style='background: rgba(37, 37, 37, 1); color: rgba(255, 255, 255, 1)'><div class='card-content'><span class='card-title'>About Universal Dashboard</span><p>Universal Dashboard is a cross-platform PowerShell module used to design beautiful dashboards from any available dataset. Visit GitHub to see some example dashboards.</p></div><div class='card-action'><a href='https://www.github.com/adamdriscoll/poshprotools'>GitHub</a></div></div>"
            }
            New-UDColumn -Size 3 {
                New-UDMonitor -Title "Antal aktiva processer" -Type Line -DataPointHistory 20 -RefreshInterval 15 -ChartBackgroundColor '#5955FF90' -ChartBorderColor '#FF55FF90' @Colors -Endpoint {
                    (Get-Process).count | Out-UDMonitorData
                } 
            }
            New-UDColumn -Size 3 {
                New-UDMonitor -Title "Antal startade tjänster" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor '#59FF681B' -ChartBorderColor '#FFFF681B' @Colors -Endpoint {
                    (Get-Service | Where-Object status -eq "running").count | Out-UDMonitorData
                } 
            }
            New-UDColumn -Size 3 {
                New-UDMonitor -Title "Ledigt minne procent" -Type Line -DataPointHistory 20 -RefreshInterval 20 -ChartBackgroundColor '#595479FF' -ChartBorderColor '#FF5479FF' @Colors -Endpoint {
                    (Get-Ciminstance Win32_OperatingSystem | select  @{Name = "Procent_Fritt"; Expression = {[math]::Round(($_.FreePhysicalMemory/$_.TotalVisibleMemorySize)*100,2)}}).procent_Fritt | Out-UDMonitorData
                } 
            }
        }
        New-UDRow {
            New-UDColumn -Size 6 {
                New-UDChart -Title "Serverinstallationer" -Type Bar -AutoRefresh -RefreshInterval 7 @Colors -Endpoint {
                    
                    $features = @();
                    $features += [PSCustomObject]@{ "OperatingSystem" = "Windows 2008 R2 Std"; "AntalInstallationer" = ($servers | Where-Object OperatingSystem -Like "Windows Server 2008 R2 Standard").count }
                    $features += [PSCustomObject]@{ "OperatingSystem" = "Windows 2008 R2 Ent"; "AntalInstallationer" = ($servers | Where-Object OperatingSystem -Like "Windows Server 2008 R2 Enterprise").count }
                    $features += [PSCustomObject]@{ "OperatingSystem" = "Windows 2008 Std"; "AntalInstallationer" = ($servers | Where-Object OperatingSystem -Like "Windows Server® 2008 Standard").count }
                    $features += [PSCustomObject]@{ "OperatingSystem" = "Windows 2012 Std"; "AntalInstallationer" = ($servers | Where-Object OperatingSystem -Like "Windows Server 2012 Standard").count }
                    $features += [PSCustomObject]@{ "OperatingSystem" = "Windows 2012 R2 Std"; "AntalInstallationer" = ($servers | Where-Object OperatingSystem -Like "Windows Server 2012 R2 Standard").count }
                    $features| Out-UDChartData -LabelProperty "OperatingSystem" -Dataset @(
                        
                        New-UDChartDataset -DataProperty "AntalInstallationer" -Label "Antal Installationer" -BackgroundColor "#803AE8CE" -HoverBackgroundColor "#803AE8CE"
                    )
                }
            }
            New-UDColumn -Size 6 {
                New-UDGrid -Title "Top GitHub Issues" @Colors -Headers @("ID", "Title", "Description", "Comments") -Properties @("ID", "Title", "Description", "Comments") -AutoRefresh -RefreshInterval 20 -Endpoint {
                    $issues = @();
                    $issues += [PSCustomObject]@{ "ID" = (Get-Random -Minimum 10 -Maximum 10000);  "Title" = "Product is too awesome...";  "Description" = "Universal Desktop is just too awesome."; Comments = (Get-Random -Minimum 10 -Maximum 10000) }
                    $issues += [PSCustomObject]@{ "ID" = (Get-Random -Minimum 10 -Maximum 10000);  "Title" = "Support for running on a PS4";  "Description" = "A dashboard on a PS4 would be pretty cool."; Comments = (Get-Random -Minimum 10 -Maximum 10000) }
                    $issues += [PSCustomObject]@{ "ID" = (Get-Random -Minimum 10 -Maximum 10000);  "Title" = "Bug in the flux capacitor";  "Description" = "The flux capacitor is constantly crashing."; Comments = (Get-Random -Minimum 10 -Maximum 10000) }
                    $issues += [PSCustomObject]@{ "ID" = (Get-Random -Minimum 10 -Maximum 10000);  "Title" = "Feature Request - Hypnotoad Widget";  "Description" = "Every dashboard needs more hypnotoad"; Comments = (Get-Random -Minimum 10 -Maximum 10000) }
                    
                    $issues | Out-UDGridData
                }
            }
        }
    }
} 

Start-Process http://localhost:$i