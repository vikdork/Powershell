function test 
{
    


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
    
   

}