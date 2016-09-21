Add-Type -Assembly PresentationFramework            
Add-Type -Assembly PresentationCore
Add-Type –assemblyName WindowsBase

[xml]$xaml = @"
<Window 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="MainWindow" Height="350" Width="525">
    <Grid>
        <GroupBox Header="GroupBox" HorizontalAlignment="Left" Margin="216,137,0,0" VerticalAlignment="Top"/>
        <Label Content="Label" HorizontalAlignment="Left" Margin="92,194,0,0" VerticalAlignment="Top"/>
        <GridSplitter HorizontalAlignment="Left" Height="100" Margin="21,87,0,0" VerticalAlignment="Top" Width="5"/>
        <Expander Header="Expander" HorizontalAlignment="Left" Margin="242,65,0,0" VerticalAlignment="Top">
            <Grid Background="#FFE5E5E5"/>
        </Expander>

    </Grid>
</Window>
"@

$reader=(New-Object System.Xml.XmlNodeReader $xaml)
$Window=[Windows.Markup.XamlReader]::Load( $reader )
$Window.ShowDialog() | Out-Null