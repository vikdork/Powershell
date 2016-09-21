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

#Lägg in en switch på att visa och inte visa samtliga tjänster. 

function get-huddservices 
{
    [CmdletBinding()]

    Param(
        [Parameter(Mandatory=$True)]
        [string]$Server,
        [switch]$Allservices)

        #Lägg in lista på alla tjänster som ska exkluderas.
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

      
      #Export tryck på exportknapp
      
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
     # POC export CSV
     write-host $servicesArray.count
     $servicesArray | Export-Csv c:\temp\exp.csv -NoTypeInformation -Encoding UTF8 -Delimiter ";"
       
       
       
       
       
       
        })
      
      $Form.ShowDialog() | out-null
      