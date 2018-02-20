



[xml]$XAML = @'

<Window 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:Flient_Felsökning"
        Title="Flient Felsökning" Height="222.654" Width="416.877">
    <Grid Margin="0,0,2,29">
        <Label Name="labelPing" Content="Test Ping" HorizontalAlignment="Left" Margin="29,116,0,0" VerticalAlignment="Top" Width="119"/>
        <Label Name="labelDns" Content="Test DNS" HorizontalAlignment="Left" Margin="29,85,0,0" VerticalAlignment="Top" Width="119"/>
        <Label Name="labelGateway" Content="Test Gateway" HorizontalAlignment="Left" Margin="29,54,0,0" VerticalAlignment="Top" Width="119"/>
        <Label Name="labelDatornamn" Content="Datornamn:" HorizontalAlignment="Left" Margin="29,23,0,0" VerticalAlignment="Top" Width="76"/>
        <CheckBox Name="checkboxGatewaySucces" Content="Succes" HorizontalAlignment="Left" Margin="166,60,0,0" VerticalAlignment="Top"/>
        <CheckBox Name="checkBoxGatewayFail" Content="Fail" HorizontalAlignment="Left" Margin="276,60,0,0" VerticalAlignment="Top"/>
        <CheckBox Name="checkBoxPingFail" Content="Fail" HorizontalAlignment="Left" Margin="276,122,0,0" VerticalAlignment="Top"/>
        <CheckBox Name="checkBoxPingSucces" Content="Succes" HorizontalAlignment="Left" Margin="166,122,0,0" VerticalAlignment="Top"/>
        <CheckBox Name="checkBoxDnsFail" Content="Fail" HorizontalAlignment="Left" Margin="276,91,0,0" VerticalAlignment="Top" RenderTransformOrigin="0.444,0.754"/>
        <CheckBox Name="checkBoxDnsSucces" Content="Succes" HorizontalAlignment="Left" Margin="166,91,0,0" VerticalAlignment="Top"/>
        <Label Name="labelDatornamnResultat" Content="" HorizontalAlignment="Left" Margin="110,23,0,0" VerticalAlignment="Top" Width="112"/>
        <Label Name="labelIp" Content="IP:" HorizontalAlignment="Left" Margin="222,23,0,0" VerticalAlignment="Top" Width="26"/>
        <Label Name="labellIpResultat" Content="" HorizontalAlignment="Left" Margin="253,23,0,0" VerticalAlignment="Top" Width="112"/>

    </Grid>
</Window>

'@

$reader=(New-Object System.Xml.XmlNodeReader $xaml) 
try{$Form=[Windows.Markup.XamlReader]::Load( $reader )}
catch{Write-Host "Unable to load Windows.Markup.XamlReader. Some possible causes for this problem include: .NET Framework is missing PowerShell must be launched with PowerShell -sta, invalid XAML code was encountered."; exit}
$xaml.SelectNodes("//*[@Name]") | foreach {Set-Variable -Name ($_.Name) -Value $Form.FindName($_.Name)}

$activNic = Get-NetIPAddress -AddressState Preferred -AddressFamily IPv4 | where InterfaceIndex -NotLike 1
$Ip = $activNic.IPAddress
$NetIpConfig = Get-NetIPConfiguration -InterfaceIndex $activNic.ifIndex


   if (Test-Connection -Quiet -Count 1 $NetIpConfig.IPv4DefaultGateway.NextHop)
   {
       $checkboxGatewaySucces.IsChecked = "Checked"
       $checkboxGatewaySucces.Foreground = "Green"
   }
   else
   {
       $checkBoxGatewayFail.IsChecked = "Checked"
       $checkBoxGatewayFail.Foreground = "Red"
   } 
       #check DNS
       $dnsCheck = [bool](Resolve-DnsName -Name test-viktor01 -ErrorAction SilentlyContinue -QuickTimeout)
            if ($dnsCheck)
            {
                $checkBoxDnsSucces.IsChecked = "Checked"
                $checkBoxDnsSucces.Foreground = "Green"
            }
            else
            {
                $checkBoxDnsFail.IsChecked = "Checked"
                $checkBoxDnsFail.Foreground = "Red"
            }

                #Ping serverhall
                    if (Test-Connection -ComputerName adm.huddinge.se -Quiet -Count 1)
                    {
                        $checkBoxPingSucces.IsChecked = "Checked"
                        $checkBoxPingSucces.Foreground = "Green"
                    }
                    else
                    {
                        $checkBoxPingFail.IsChecked = "Checked"
                        $checkBoxPingFail.Foreground = "Red"
                    }


$labelDatornamnResultat.Content = $env:COMPUTERNAME
$labellIpResultat.Content = $Ip
    

$Form.ShowDialog() | out-null


