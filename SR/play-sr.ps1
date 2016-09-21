###########################GUI########################################

[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')

[xml]$XAML = @'
<Window 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="SR" Height="304" Width="465">
    <Grid>
        <Slider HorizontalAlignment="Left" Margin="24,245,0,0" VerticalAlignment="Top" Width="150"/>
        <Button Name="bP4" Content="P4" HorizontalAlignment="Left" Margin="24,138,0,0" VerticalAlignment="Top" Width="75"/>
        <Button Name="bP3" Content="P3" HorizontalAlignment="Left" Margin="24,100,0,0" VerticalAlignment="Top" Width="75"/>
        <Button Name="bP2" Content="P2" HorizontalAlignment="Left" Margin="24,60,0,0" VerticalAlignment="Top" Width="75"/>
        <Button Name="bP1" Content="P1" HorizontalAlignment="Left" Margin="24,22,0,0" VerticalAlignment="Top" Width="75"/>
        <Label Content="Spelar nu:" HorizontalAlignment="Left" Margin="24,173,0,0" VerticalAlignment="Top" Width="79" FontSize="16"/>
        <Label Name ="spelar" Content="test" HorizontalAlignment="Left" Margin="108,173,0,0" VerticalAlignment="Top" FontSize="16"/>
        <Image Margin="235,-31,22,100" Source="c:\sr\srlogg.gif" Stretch="Fill" Width="200" Height="200"/>
        <Label Name="lVolym" Content="Volym" HorizontalAlignment="Left" Margin="69,220,0,0" VerticalAlignment="Top" RenderTransformOrigin="0.211,-0.077" FontStretch="SemiCondensed" Width="48" Height="26"/>
        <Button Name="bAvsluta" Content="Stop" HorizontalAlignment="Left" Margin="269,220,0,0" VerticalAlignment="Top" Width="113" Height="31" FontSize="14"/>
    </Grid>
</Window>

'@
$reader=(New-Object System.Xml.XmlNodeReader $xaml) 
try{$Form=[Windows.Markup.XamlReader]::Load( $reader )}
catch{Write-Host "Unable to load Windows.Markup.XamlReader. Some possible causes for this problem include: .NET Framework is missing PowerShell must be launched with PowerShell -sta, invalid XAML code was encountered."; exit}


############## Variables ##################################
 $xaml.SelectNodes("//*[@Name]") | foreach {Set-Variable -Name ($_.Name) -Value $Form.FindName($_.Name)}
 $P1 = "http://sverigesradio.se/topsy/direkt/132-hi-mp3.m3u"
 $P2 = "http://sverigesradio.se/topsy/direkt/2562-hi-mp3.m3u"
 $P3 = "http://sverigesradio.se/topsy/direkt/164-hi-mp3.m3u"
 $P4 = "http://sverigesradio.se/topsy/direkt/179-hi-mp3.m3u"
 
$MediaPlayer = New-Object System.Windows.Media.MediaPlayer 

############# Main ##########################

$bP1.add_click({ 
 $MediaPlayer.Open([uri]$p1)
$MediaPlayer.play()
$spelar.Content = "P1"
})

$bP2.add_click({ 
$MediaPlayer.Open([uri]$p2)
$MediaPlayer.play()
$spelar.Content = "P2"
})

$bP3.add_click({ 
    $MediaPlayer.Open([uri]$p3)
$MediaPlayer.play()
$spelar.Content = "P3"
})

$bP4.add_click({
    $MediaPlayer.Open([uri]$p4)
$MediaPlayer.play()
$spelar.Content = "P4"
})


$bAvsluta.add_click({$MediaPlayer.stop() 
    $MediaPlayer.close()
     })
     $Form.Add_Closing({$MediaPlayer.stop() 
    $MediaPlayer.close()})
$Form.ShowDialog() | out-null
