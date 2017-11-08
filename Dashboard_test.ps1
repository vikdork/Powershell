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
            New-UDColumn -Size 5 {
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
            
        }
 

                   
                
                New-UDRow {
            New-UDColumn -Size 5 {
                New-UDChart -Title "Releaser per vecka" -Type Bar -AutoRefresh -RefreshInterval 7 @Colors -Endpoint {
                    $date = Get-Date -UFormat %V
                                              #Declare Variables
$EWSDLL = "C:\Program Files\Microsoft\Exchange\Web Services\2.2\Microsoft.Exchange.WebServices.dll"
$MBX = "Kalender.KSF-IT-avdelning-Driftkalender@huddinge.se"
$EWSURL = "https://srv-exch01/EWS/Exchange.asmx"
$StartDate = (Get-Date).AddDays(-90)
$EndDate = (Get-Date)  

## Choose to ignore any SSL Warning issues caused by Self Signed Certificates  
  
## Code From http://poshcode.org/624
## Create a compilation environment
$Provider=New-Object Microsoft.CSharp.CSharpCodeProvider
$Compiler=$Provider.CreateCompiler()
$Params=New-Object System.CodeDom.Compiler.CompilerParameters
$Params.GenerateExecutable=$False
$Params.GenerateInMemory=$True
$Params.IncludeDebugInformation=$False
$Params.ReferencedAssemblies.Add("System.DLL") | Out-Null

$TASource=@'
  namespace Local.ToolkitExtensions.Net.CertificatePolicy{
    public class TrustAll : System.Net.ICertificatePolicy {
      public TrustAll() { 
      }
      public bool CheckValidationResult(System.Net.ServicePoint sp,
        System.Security.Cryptography.X509Certificates.X509Certificate cert, 
        System.Net.WebRequest req, int problem) {
        return true;
      }
    }
  }
'@ 
$TAResults=$Provider.CompileAssemblyFromSource($Params,$TASource)
$TAAssembly=$TAResults.CompiledAssembly

## We now create an instance of the TrustAll and attach it to the ServicePointManager
$TrustAll=$TAAssembly.CreateInstance("Local.ToolkitExtensions.Net.CertificatePolicy.TrustAll")
[System.Net.ServicePointManager]::CertificatePolicy=$TrustAll

## end code from http://poshcode.org/624




#Binding of the calendar of the Mailbox and EWS
Import-Module -Name $EWSDLL
$mailboxname = $MBX
$service = new-object Microsoft.Exchange.WebServices.Data.ExchangeService([Microsoft.Exchange.WebServices.Data.Exchangeversion]::exchange2013)
$service.Url = new-object System.Uri($EWSURL)
$folderid= new-object Microsoft.Exchange.WebServices.Data.FolderId([Microsoft.Exchange.WebServices.Data.WellKnownFolderName]::Calendar,$MailboxName) 
$Calendar = [Microsoft.Exchange.WebServices.Data.Folder]::Bind($service,$folderid)  
$Recurring = new-object Microsoft.Exchange.WebServices.Data.ExtendedPropertyDefinition([Microsoft.Exchange.WebServices.Data.DefaultExtendedPropertySet]::Appointment, 0x8223,[Microsoft.Exchange.WebServices.Data.MapiPropertyType]::Boolean); 
$psPropset= new-object Microsoft.Exchange.WebServices.Data.PropertySet([Microsoft.Exchange.WebServices.Data.BasePropertySet]::FirstClassProperties)  
$psPropset.Add($Recurring)
$psPropset.RequestedBodyType = [Microsoft.Exchange.WebServices.Data.BodyType]::Text;

$RptCollection = @()

$AppointmentState = @{0 = "None" ; 1 = "Meeting" ; 2 = "Received" ;4 = "Canceled" ; }

#Define the calendar view  
$CalendarView = New-Object Microsoft.Exchange.WebServices.Data.CalendarView($StartDate,$EndDate,1000)    
$fiItems = $service.FindAppointments($Calendar.Id,$CalendarView)
if($fiItems.Items.Count -gt 0){
 $type = ("System.Collections.Generic.List"+'`'+"1") -as "Type"
 $type = $type.MakeGenericType("Microsoft.Exchange.WebServices.Data.Item" -as "Type")
 $ItemColl = [Activator]::CreateInstance($type)
 foreach($Item in $fiItems.Items){
  $ItemColl.Add($Item)
 } 
 [Void]$service.LoadPropertiesForItems($ItemColl,$psPropset)  
}
foreach($Item in $fiItems.Items){      
 $rptObj = "" | Select StartTime,EndTime,Duration,Type,Subject,Location,Organizer,Attendees,AppointmentState,Notes,HasAttachments,IsReminderSet,Categories
 $rptObj.StartTime = $Item.Start  
 $rptObj.EndTime = $Item.End  
 $rptObj.Duration = $Item.Duration
 $rptObj.Subject  = $Item.Subject   
 $rptObj.Type = $Item.AppointmentType
 $rptObj.Location = $Item.Location
 $rptObj.Organizer = $Item.Organizer.Address
 $rptObj.HasAttachments = $Item.HasAttachments
 $rptObj.IsReminderSet = $Item.IsReminderSet
 $rptObj.Categories = $item.Categories
 $aptStat = "";
 $AppointmentState.Keys | where { $_ -band $Item.AppointmentState } | foreach { $aptStat += $AppointmentState.Get_Item($_) + " "}
 $rptObj.AppointmentState = $aptStat 
 $RptCollection += $rptObj
 foreach($attendee in $Item.RequiredAttendees){
  $atn = $attendee.Address + "; "  
  $rptObj.Attendees += $atn
  }
 foreach($attendee in $Item.OptionalAttendees){
  $atn = $attendee.Address + "; "  
  $rptObj.Attendees += $atn
 }
 <#
 foreach($attendee in $Item.Resources){
  $atn = $attendee.Address + "; "  
  $rptObj.Resources += $atn
 }
 #>

# Bortkommenterade nedan då det pajade kommaseparering, radbryt
$rptObj.Notes = $Item.Body.Text
#Display on the screen
 "Start:   " + $Item.Start  
 "Subject: " + $Item.Subject 
}   
#Export to a CSVFile

    for ($y = 0; $y -lt $RptCollection.count ; $y++)
    { 
        $RptCollection[$y] | Add-Member -MemberType NoteProperty -Value ($RptCollection.starttime[$y] |get-date -UFormat %V) -Name "Weekday"
    }
    

                    $Releases = @();
                    $Releases += [PSCustomObject]@{ "AntalReleaserPerVecka" = $date ; "Vecka" = ($RptCollection | where weekday -eq $date).count }
                    $Releases += [PSCustomObject]@{ "AntalReleaserPerVecka" = $date -1 ; "Vecka" = ($RptCollection | where weekday -eq ($date -1)).count }
                    $Releases += [PSCustomObject]@{ "AntalReleaserPerVecka" = $date -2; "Vecka" = ($RptCollection | where weekday -eq ($date -2)).count }
                    $Releases += [PSCustomObject]@{ "AntalReleaserPerVecka" = $date -3; "Vecka" = ($RptCollection | where weekday -eq ($date -3)).count }
                    $Releases | Out-UDChartData -LabelProperty "AntalReleaserPerVecka" -Dataset @(
                        
                        New-UDChartDataset -DataProperty "Vecka" -Label "Antal Installationer" -BackgroundColor "#803AE8CE" -HoverBackgroundColor "#803AE8CE" -
                    )
                }
            }
            
        }
    }
} 

Start-Process http://localhost:$i


<#

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

            #>