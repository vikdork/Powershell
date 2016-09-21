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
        <CheckBox Name="Checkboxp1" Content="" HorizontalAlignment="Left" Margin="108,25,0,0" VerticalAlignment="Top"/>
        <CheckBox Name="Checkboxp2" Content="" HorizontalAlignment="Left" Margin="108,63,0,0" VerticalAlignment="Top"/>
        <CheckBox Name="checkboxp4" Content="" HorizontalAlignment="Left" Margin="108,141,0,0" VerticalAlignment="Top"/>
        <CheckBox Name="checkboxp3" Content="" HorizontalAlignment="Left" Margin="108,103,0,0" VerticalAlignment="Top"/>
        <Label Content="Spelar nu:" HorizontalAlignment="Left" Margin="24,173,0,0" VerticalAlignment="Top" Width="79" FontSize="16"/>
        <Label Content="test" HorizontalAlignment="Left" Margin="108,173,0,0" VerticalAlignment="Top" FontSize="16"/>
        <Image Margin="235,-31,22,100" Source="srlogg.gif" Stretch="Fill" Width="200" Height="200"/>
        <Label Name="lVolym" Content="Volym" HorizontalAlignment="Left" Margin="69,220,0,0" VerticalAlignment="Top" RenderTransformOrigin="0.211,-0.077" FontStretch="SemiCondensed" Width="48" Height="26"/>
        <Button Name="bPlay" Content="Play" HorizontalAlignment="Left" Margin="269,173,0,0" VerticalAlignment="Top" Width="113" Height="31" FontSize="14"/>
        <Button Name="bAvsluta" Content="Avsluta" HorizontalAlignment="Left" Margin="269,220,0,0" VerticalAlignment="Top" Width="113" Height="31" FontSize="14"/>
    </Grid>
</Window>

'@
$reader=(New-Object System.Xml.XmlNodeReader $xaml) 
try{$Form=[Windows.Markup.XamlReader]::Load( $reader )}
catch{Write-Host "Unable to load Windows.Markup.XamlReader. Some possible causes for this problem include: .NET Framework is missing PowerShell must be launched with PowerShell -sta, invalid XAML code was encountered."; exit}
$xaml.SelectNodes("//*[@Name]") | foreach {Set-Variable -Name ($_.Name) -Value $Form.FindName($_.Name)}


############### Radio function ##################

#function SR-Play{
# param 
 #([parameter(mandatory)]
 #[ValidateSet("P1","P2","P3","P4")]
 #[String]$Radiostation)

 $P1 = "http://sverigesradio.se/topsy/direkt/132-hi-mp3.m3u"
 $P2 = "http://sverigesradio.se/topsy/direkt/2562-hi-mp3.m3u"
 $P3 = "http://sverigesradio.se/topsy/direkt/164-hi-mp3.m3u"
 $P4 = "http://sverigesradio.se/topsy/direkt/179-hi-mp3.m3u"
 
$MediaPlayer = New-Object System.Windows.Media.MediaPlayer 

#switch ($Radiostation)
#{
 #   "P1" {$MediaPlayer.Open([uri]$p1)}
  #  "P2" {$MediaPlayer.Open([uri]$p2)}
   # "P3" {$MediaPlayer.Open([uri]$p3)}
    #"P4" {$MediaPlayer.Open([uri]$p4)}
#}
#$MediaPlayer.play()
#Start-Sleep -Seconds 1

 <#   do {
    [int]$meny = 0

    while ( $meny -lt 1 -or $meny -gt 9) {
    write-host "Kanalmeny, välj kanal eller avsluta."
    Write-Host "1. P1"
    Write-Host "2. P2"
    Write-Host "3. P3"
    Write-Host "4. P4"
    Write-Host "9. Avsluta"

    [int]$meny = Read-Host "Välj en kanal"

    switch ($meny) {
      1{Write-Host "P1"
      $MediaPlayer.Open([uri]$p1)
$MediaPlayer.play()}
      2{Write-Host "p2"
      $MediaPlayer.Open([uri]$p2)
$MediaPlayer.play()}
      3{Write-Host "p3"
      $MediaPlayer.Open([uri]$p3)
$MediaPlayer.play()}
      4{Write-host "p4"
      $MediaPlayer.Open([uri]$p4)
$MediaPlayer.play()}
      9{Write-Host "Hejdå"}
      default {Write-Host "Fel val"}
    }
  }
  
    }
until ("9" -ccontains $meny
)
 if ($meny -eq "9")
    {$MediaPlayer.stop() 
    $MediaPlayer.close()
     }
}
#>

#}
############# Main ##########################

$bP1.add_click({ 
 $MediaPlayer.Open([uri]$p1)
$MediaPlayer.play()
})

$bP2.add_click({ 
$MediaPlayer.Open([uri]$p2)
$MediaPlayer.play()
})

$bP3.add_click({ 
    $MediaPlayer.Open([uri]$p3)
$MediaPlayer.play()
})

$bP4.add_click({
    $MediaPlayer.Open([uri]$p4)
$MediaPlayer.play()
})





$Form.ShowDialog() | out-null