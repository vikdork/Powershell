#build GUI

[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')

[xml]$XAML = @'

<Window x:Name="Create_Nano_Servers" x:Class="create_nano_server.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:create_nano_server"
        mc:Ignorable="d"
        Title="MainWindow" Height="483.193" Width="705.901">
    <Grid>
        <Label x:Name="labelComputername" Content="Computer name:" HorizontalAlignment="Left" Margin="24,28,0,0" VerticalAlignment="Top" Width="111" Height="26"/>
        <Label x:Name="labelFeaturesAndRoles" Content="Feature and roles:" HorizontalAlignment="Left" Margin="24,73,0,0" VerticalAlignment="Top" FontWeight="Bold" Height="26" Width="111"/>
        <CheckBox x:Name="checkBoxHyper" Content="Hyper-V role" HorizontalAlignment="Left" Margin="33,108,0,0" VerticalAlignment="Top" Height="15" Width="88"/>
        <CheckBox x:Name="checkBoxFailover" Content="Failover Clustering" HorizontalAlignment="Left" Margin="33,128,0,0" VerticalAlignment="Top" Height="15" Width="117" Grid.RowSpan="2"/>
        <CheckBox x:Name="checkBoxBasic" Content="Basic drivers for a variety of network adapters and storage controllers." HorizontalAlignment="Left" Margin="33,15,0,0" VerticalAlignment="Top" Grid.Row="1" Height="15" Width="389"/>
        <CheckBox x:Name="checkBoxFile" Content="File Server role and other storage components" HorizontalAlignment="Left" Margin="33,35,0,0" VerticalAlignment="Top" Grid.Row="1" Height="15" Width="265"/>
        <CheckBox x:Name="checkBoxWindowsDefender" Content="Windows Defender Antimalware" HorizontalAlignment="Left" Margin="33,54,0,0" VerticalAlignment="Top" Grid.Row="1" Height="15" Width="190"/>
        <CheckBox x:Name="checkBoxReverse" Content="Reverse forwarders for application compatibility" HorizontalAlignment="Left" Margin="33,75,0,0" VerticalAlignment="Top" Grid.Row="1" Height="15" Width="272"/>
        <CheckBox x:Name="checkBoxDns" Content="DNS Server role" HorizontalAlignment="Left" Margin="33,95,0,0" VerticalAlignment="Top" Grid.Row="1" Height="15" Width="104"/>
        <CheckBox x:Name="checkBoxDcs" Content="Desired State Configuration (DSC)" HorizontalAlignment="Left" Margin="33,115,0,0" VerticalAlignment="Top" Grid.Row="1" Height="15" Width="199"/>
        <CheckBox x:Name="checkBoxIis" Content="Internet Information Server (IIS)" HorizontalAlignment="Left" Margin="33,135,0,0" VerticalAlignment="Top" Grid.Row="1" Height="15" Width="187"/>
        <CheckBox x:Name="checkBoxContainers" Content="Host support for Windows Containers" HorizontalAlignment="Left" Margin="33,155,0,0" VerticalAlignment="Top" Grid.Row="1" Height="15" Width="220"/>
        <CheckBox x:Name="checkBoxSystemCenter" Content="System Center Virtual Machine Manager agent" HorizontalAlignment="Left" Margin="33,175,0,0" VerticalAlignment="Top" Grid.Row="1" Height="15" Width="266"/>
        <CheckBox x:Name="checkBoxNpds" Content="Network Performance Diagnostics Service (NPDS)" HorizontalAlignment="Left" Margin="33,195,0,0" VerticalAlignment="Top" Grid.Row="1" Height="15" Width="281"/>
        <CheckBox x:Name="checkBoxDcb" Content="Data Center Bridging" HorizontalAlignment="Left" Margin="33,215,0,0" VerticalAlignment="Top" Grid.Row="1" Height="15" Width="131"/>
        <TextBox x:Name="textBoxComputerName" HorizontalAlignment="Left" Height="23" Margin="133,32,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="120"/>
        <Label x:Name="labelServers" Content="Servers:" HorizontalAlignment="Left" Margin="382,28,0,0" VerticalAlignment="Top" Height="26" Width="51"/>
        <ListBox x:Name="listBox" HorizontalAlignment="Left" Height="332" Margin="456,32,0,0" Grid.RowSpan="2" VerticalAlignment="Top" Width="227"/>
        <Button x:Name="buttonAddServer" Content="Add Server" HorizontalAlignment="Left" Margin="33,247,0,0" Grid.Row="1" VerticalAlignment="Top" Width="75" Height="20"/>
        <Button x:Name="buttonCreateServers" Content="Create Servers" HorizontalAlignment="Left" Margin="456,247,0,0" Grid.Row="1" VerticalAlignment="Top" Width="85" Height="20"/>

    </Grid>
</Window>

'@

$reader=(New-Object System.Xml.XmlNodeReader $xaml) 
try{$Form=[Windows.Markup.XamlReader]::Load( $reader )}
catch{Write-Host "Unable to load Windows.Markup.XamlReader. Some possible causes for this problem include: .NET Framework is missing PowerShell must be launched with PowerShell -sta, invalid XAML code was encountered."; exit}
$xaml.SelectNodes("//*[@Name]") | foreach {Set-Variable -Name ($_.Name) -Value $Form.FindName($_.Name)}

 $Form.ShowDialog() | out-null