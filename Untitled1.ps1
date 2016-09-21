[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
#
#Add-Type -Assembly PresentationFramework            
#Add-Type -Assembly PresentationCore
#Add-Type –assemblyName WindowsBase


[xml]$XAML = @'


<Window
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Test" Height="414" Width="615">
    <Grid Margin="1,0,-1,0">
        <Label Content="Hostname" HorizontalAlignment="Left" Margin="10,42,0,0" VerticalAlignment="Top" Background="#FF3EB7E4" Height="32" Width="126" FontFamily="Calibri" FontSize="16"/>
        <Label Content="                                                                    Operating System Details" HorizontalAlignment="Left" Margin="10,10,0,0" VerticalAlignment="Top" Width="587" FontFamily="Calibri" Background="#FF3EB7E4" Height="27" FontSize="14"/>
        <Label Content="System Drive" HorizontalAlignment="Left" Margin="10,264,0,0" VerticalAlignment="Top" Background="#FF3EB7E4" Height="32" Width="126" FontFamily="Calibri" FontSize="16"/>
        <Label Content="Windows Version" HorizontalAlignment="Left" Margin="10,227,0,0" VerticalAlignment="Top" Background="#FF3EB7E4" Height="32" Width="126" FontFamily="Calibri" FontSize="16"/>
        <Label Content="Windows Directory" HorizontalAlignment="Left" Margin="10,190,0,0" VerticalAlignment="Top" Background="#FF3EB7E4" Height="32" Width="126" FontFamily="Calibri" FontSize="16"/>
        <Label Content="OS Architecture" HorizontalAlignment="Left" Margin="10,153,0,0" VerticalAlignment="Top" Background="#FF3EB7E4" Height="32" Width="126" FontFamily="Calibri" FontSize="16"/>
        <Label Content="Available Memory" HorizontalAlignment="Left" Margin="10,116,0,0" VerticalAlignment="Top" Background="#FF3EB7E4" Height="32" Width="126" FontFamily="Calibri" FontSize="16"/>
        <Label Content="Operating System Name" HorizontalAlignment="Left" Margin="10,79,0,0" VerticalAlignment="Top" Background="#FF3EB7E4" Height="32" Width="126" FontFamily="Calibri" FontSize="16"/>
        <TextBox Name="txtHostName" HorizontalAlignment="Left" Height="32" Margin="141,42,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="456"/>
        <TextBox Name="txtOSName" HorizontalAlignment="Left" Height="32" Margin="141,79,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="456"/>
        <TextBox Name="txtAvailableMemory" HorizontalAlignment="Left" Height="32" Margin="141,116,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="456"/>
        <TextBox Name="txtOSArchitecture" HorizontalAlignment="Left" Height="32" Margin="141,153,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="456"/>
        <TextBox Name="txtWindowsDirectory" HorizontalAlignment="Left" Height="32" Margin="141,190,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="456"/>
        <TextBox Name="txtWindowsVersion" HorizontalAlignment="Left" Height="32" Margin="141,227,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="456"/>
        <TextBox Name="txtSystemDrive" HorizontalAlignment="Left" Height="32" Margin="141,264,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="456"/>
                <Slider Name="slider" HorizontalAlignment="Left" Margin="115,337,0,0" VerticalAlignment="Top" Width="274" Minimum="1" Maximum="8" SmallChange="1"/>
        <Label Name="sliderlabel" Content="" HorizontalAlignment="Left" Margin="426,337,0,0" VerticalAlignment="Top" Width="50"/>

    </Grid>
</Window>
'@



$reader=(New-Object System.Xml.XmlNodeReader $xaml) 
try{$Form=[Windows.Markup.XamlReader]::Load( $reader )}
catch{Write-Host "Unable to load Windows.Markup.XamlReader. Some possible causes for this problem include: .NET Framework is missing PowerShell must be launched with PowerShell -sta, invalid XAML code was encountered."; exit}


$xaml.SelectNodes("//*[@Name]") | foreach {Set-Variable -Name ($_.Name) -Value $Form.FindName($_.Name)}



$info = Get-WmiObject win32_operatingsystem

$txtHostName.text = $info.PSComputerName

$os = $info.Name.Split("|")
$txtOSName.Text = $os[0]
$freemem = $info.FreePhysicalMemory * 1KB / 1GB
$txtAvailableMemory.text = "{0:N2}" -f ($freemem) + " GB"
$txtOSArchitecture = $info.OSArchitecture
$txtSystemDrive = $info.SystemDrive
$txtWindowsDirectory = $info.WindowsDirectory
$txtWindowsVersion = $info.Version


$sliderlabel.Content = "{0} GB" -f ($Slider.Value -as [int]) 
$Slider.add_ValueChanged({

    $sliderlabel.content = "{0} GB" -f ($Slider.Value -as [int]) 


})

$Form.ShowDialog() | out-null