#build GUI

[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')

[xml]$XAML = @'

<Window
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="MainWindow" Height="502" Width="573">
    <Grid>
        <ListBox Name="listboxServices" HorizontalAlignment="Left" Height="409" Margin="394,34,0,0" VerticalAlignment="Top" Width="149"/>
        <Label Name="labelComputername" Content="Computername" HorizontalAlignment="Left" Margin="40,41,0,0" VerticalAlignment="Top" Height="27" Width="99"/>
        <TextBox Name="textBoxComputerName" HorizontalAlignment="Left" Height="23" Margin="199,45,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="177"/>
        <Button Name="buttonGetServices" Content="Get Services" HorizontalAlignment="Left" Margin="40,88,0,0" VerticalAlignment="Top" Width="131" Height="24"/>
        <Button Name="buttonCreateWiki" Content="Create Wikitext" HorizontalAlignment="Left" Margin="40,133,0,0" VerticalAlignment="Top" Width="131" Height="25"/>
        <CheckBox Name="checkBoxServices" Content="Show all services" HorizontalAlignment="Left" Margin="199,93,0,0" VerticalAlignment="Top" Width="137"/>

    </Grid>
</Window>
'@

$reader=(New-Object System.Xml.XmlNodeReader $xaml) 
try{$Form=[Windows.Markup.XamlReader]::Load( $reader )}
catch{Write-Host "Unable to load Windows.Markup.XamlReader. Some possible causes for this problem include: .NET Framework is missing PowerShell must be launched with PowerShell -sta, invalid XAML code was encountered."; exit}
$xaml.SelectNodes("//*[@Name]") | foreach {Set-Variable -Name ($_.Name) -Value $Form.FindName($_.Name)}

#Function to get all services from remote computer. Switct-parameter if you want to fetch all services or just some.

function get-huddservices 
{
    [CmdletBinding()]

    Param(
        [Parameter(Mandatory=$True)]
        [string]$Server,
        [switch]$Allservices)

        # List of default services that is not listed if you don´t use the Allservices switch parameter.
        $Defaultservices = "AeLookupSvc","Appinfo","BFE","BITS","BrokerInfrastructure","CertPropSvc","COMSysApp","CryptSvc","DcomLaunch",
"Dhcp","DiagTrack","Dnscache","DPS","EventLog","EventSystem","FontCache","gpsvc","iphlpsvc","LanmanServer","LanmanWorkstation","lmhosts",
"LSM","MpsSvc","MSDTC","NcbService","Netlogonv","Netman","netprofm","NlaSvcv","nsi","ntrtscan","PlugPlay","PolicyAgent","Power","ProfSvc",
"RemoteRegistry","RpcEptMapper","RpcSs","SamSs","ScDeviceEnum","Schedule","SENS","SessionEnv","ShellHWDetection","SNMP","Spooler",
"SystemEventsBroker","TermService","Themes","TimeBroker","tmlisten","TrkWks","TrustedInstaller","UALSVC","UmRdpService","W32Time",
"Wcmsvc","WinHttpAutoProxySvc","Winmgmt","WinRM","wlidsvc","VMTools","wuauserv","Netlogon","NlaSvc","AppHostSvc","TSM Client Acceptor",
"TSM TDP Scheduler","UxSms","WAS","IKEEXT","NetPipeActivator","NetTcpActivator","NetTcpPortSharing","IISADMIN","wudfsvc","KeyIso","MSMQ","DWMRCS",
"NetMsmqActivator","CqMgStor","SysMgmtHp","sysdown","TapiSrv","CqMgServ","cpqvcagent","CpqNicMgmt","ProLiantMonitor","HPWMISTOR","TSM Client Scheduler",
"EFS","Cissesrv","CqMgHost","SCardSvr","VSS","TSM Scheduler","vmware-converter-agent","vmware-converter-server","WinDefend","aspnet_state","EapHost","TSM TDP SQL Scheduler",
"seclogon","pla"

        if ($Allservices)
        {
            $Script:allServices = get-wmiobject -ComputerName $Server win32_service | Select-Object PScomputerName, Name, DisplayName, Startmode, StartName, Description
            $Script:dependentServices = Get-Service -ComputerName $Server | Select-Object Name, DependentServices

        }
        else
        {
            $Script:allServices = get-wmiobject -ComputerName $Server win32_service | Where-Object {$_.Name -notin $Defaultservices} | Select-Object PScomputerName, Name, DisplayName, Startmode, StartName, Description
            $Script:dependentServices = Get-Service -ComputerName $Server | Where-Object {$_.Name -notin $Defaultservices} | Select-Object Name, DependentServices
          }
        }




        # Actions when Get services button is clicked.
        $buttonGetServices.add_click({
    if ($checkBoxServices.IsChecked)
    {
        get-huddservices -Server $textBoxComputerName.Text -Allservices
    }
    else
    {
        get-huddservices -Server $textBoxComputerName.Text
    }

            $listboxServices.Items.Clear()
            for ($i = 0; $i -lt $allServices.Length; $i++)
            {
                $listboxServices.Items.Add($allServices.Name[$i])
            } 
            $listboxServices.SelectionMode = "Multiple"
       })

      
      # Actions when create wiki is clicked
      
      $buttonCreateWiki.add_click({
      $servicesArray = @()
      foreach ($item in $listboxServices.SelectedItems)
      {
          $Service = $allServices | Where-Object {$_.Name -eq $item}
          $dependentService = ($dependentServices | Where-Object {$_.Name -eq $item} | select-object -ExpandProperty DependentServices).name
          
           
          $servicesArray += New-Object psobject -Property @{
                                    Name = $Service.Name
                                    Displayname = $Service.Displayname
                                    Startmode = $Service.Startmode
                                    Startname = $Service.Startname
                                    'Dependent_Services' = "$dependentService"
                                    Description = $Service.Description
                                    }
      
      }


function build-wiki 
    {
    [CmdletBinding()]
      <#  Param(
        [Parameter(Mandatory=$True,Position=1)]
        [string]$Server)  #>
            #Importera servrar och tjänster samt wikipediabas för att bygga tables i wiki
            #$wikiBas = Get-Content 'G:\Projekt\Pågående\Övervakning serverfunktionen\skript\Wiki_bas.txt'
            $wikibas = '=== Övervakning ===

Följande tjänster är kritiska, och övervakas via [[WhatsUp_Gold|Whats Up]].

{| border="1"
!Name
!Displayname
!Startmode
!Startname
!Dependent Services
!Description

|-'
           
           
           #Filepath Variables, date to uniqe
            $date = get-date -Format hhmmss
            $filePath = "c:\temp\" 
            $fileName = $date + $textBoxComputerName.Text +"_wiki.txt"

            
                #Create file and build table base.
                New-Item -ItemType File -Path $filePath -Name $fileName
                Add-Content -Value ($wikiBas) -Path $filePath$fileName -Encoding UTF8
                $script:wikifile = $filePath + $fileName
    
   
foreach ($serviceResult in $servicesArray)
{
   
add-Content -Value (
"| "+$serviceResult.Name + "||" + $serviceResult.Displayname + "||" +$serviceResult.Startmode +"||"+$serviceResult.StartName +"||" +$serviceResult.'Dependent_Services' + "||" +$serviceResult.Description +
"`r`n|-") -Path $filePath$fileName -Encoding UTF8
    }

    Add-Content -Value ("|}") -Path $filePath$fileName -Encoding UTF8
    
    }

     # POC export CSV
     build-wiki
     #write-host $servicesArray.count
     #$servicesArray | Export-Csv c:\temp\exp.csv -NoTypeInformation -Encoding UTF8 -Delimiter ";"
     notepad $wikifile
     })
      
      $Form.ShowDialog() | out-null
