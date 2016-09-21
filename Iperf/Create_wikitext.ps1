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
        <TextBox Name="textBoxComputerName" HorizontalAlignment="Left" Height="23" Margin="159,45,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="177"/>
        <Button Name="buttonGetServices" Content="Get Services" HorizontalAlignment="Left" Margin="40,88,0,0" VerticalAlignment="Top" Width="131" Height="24"/>
        <Button Name="buttonCreateWiki" Content="Create Wikitext" HorizontalAlignment="Left" Margin="40,133,0,0" VerticalAlignment="Top" Width="131" Height="25"/>
        <Label Name="label" Content="Export till" HorizontalAlignment="Left" Margin="40,186,0,0" VerticalAlignment="Top" RenderTransformOrigin="0.5,0.5" Width="306"/>

    </Grid>
</Window>

'@

$reader=(New-Object System.Xml.XmlNodeReader $xaml) 
try{$Form=[Windows.Markup.XamlReader]::Load( $reader )}
catch{Write-Host "Unable to load Windows.Markup.XamlReader. Some possible causes for this problem include: .NET Framework is missing PowerShell must be launched with PowerShell -sta, invalid XAML code was encountered."; exit}
$xaml.SelectNodes("//*[@Name]") | foreach {Set-Variable -Name ($_.Name) -Value $Form.FindName($_.Name)}

#$computername = "ksfl0153"

#Start variables
$servicesArray = @()

#Lägg in en switch på att visa och inte visa samtliga tjänster. 

function get-huddservices 
{
    [CmdletBinding()]

    Param(
        [Parameter(Mandatory=$True)]
        [string]$Server)

        $Script:allServices = get-wmiobject -ComputerName $computername win32_service | Select-Object PScomputerName, Name, DisplayName, Startmode, StartName, Description
        $Script:dependentServices = Get-Service -ComputerName $computername | Select-Object Name, DependentServices
      }

      
      
  $buttonGetServices.add_click({
    get-huddservices -Server $textBoxComputerName.Text
    #$listboxServices.Items.add ($allServices.Name)

    for ($i = 0; $i -lt $allServices.Length; $i++)
    {
        $listboxServices.Items.Add($allServices.Name[$i])
    }


  
  })

      
      
      #Export tryck på exportknapp
      
      foreach ($item in $servicenames)
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
      
      $Form.ShowDialog() | out-null
      
      
  