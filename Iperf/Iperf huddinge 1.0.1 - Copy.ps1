[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
$syncHash = [hashtable]::Synchronized(@{})
$newRunspace =[runspacefactory]::CreateRunspace()
$newRunspace.ApartmentState = "STA"
$newRunspace.ThreadOptions = "ReuseThread"         
$newRunspace.Open()
$newRunspace.SessionStateProxy.SetVariable("syncHash",$syncHash)          
$psCmd = [PowerShell]::Create().AddScript({ 

[xml]$XAML = @'

<Window 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Huddinge Kommuns Bandbredskoll" Height="280.864" Width="528.704" Background="#FFF2FDFF">
    <Grid>
        <Label Name="labelDatornamn" Content="Datornamn:" HorizontalAlignment="Left" Margin="21,44,0,0" VerticalAlignment="Top" Height="25" Width="73"/>
        <TextBox Name="textboxDatornamn" HorizontalAlignment="Left" Height="22" Margin="107,47,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="115"/>
        <Label Name="labelAlternativ" Content="Alternativ" HorizontalAlignment="Left" Margin="21,74,0,0" VerticalAlignment="Top" Width="73"/>
        <ComboBox Name="comboboxAlternativ" SelectedValuePath ="Content" HorizontalAlignment="Left" Margin="107,74,0,0" VerticalAlignment="Top" Width="115">
            <ComboBoxItem Content="1Väg"/>
            <ComboBoxItem Content="2Väg"/>
            <ComboBoxItem Content="Simultan"/>
            <ComboBoxItem Content="test"/>
        </ComboBox>
        <Button Name="buttonStartamätning" Content="Starta Mätningen" HorizontalAlignment="Left" Margin="21,115,0,0" VerticalAlignment="Top" Width="201" Height="39" FontSize="16" Background="Black" Foreground="White"/>
        <Label Name="labelResultat" Content="Resultat:" HorizontalAlignment="Left" Margin="347,10,0,0" VerticalAlignment="Top" Width="81" HorizontalContentAlignment="Center"/>
        <TextBox Name= "texboxResult" HorizontalAlignment="Left" Height="107" Margin="254,47,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="247"/>
        <Button Name="buttonExportera" Content="Exportera" HorizontalAlignment="Left" Margin="21,189,0,0" VerticalAlignment="Top" Width="109" Height="32"/>
        <Button Name="buttonAvsluta" Content="Avsluta" HorizontalAlignment="Left" Margin="392,189,0,0" VerticalAlignment="Top" Width="109" Height="32"/>
        <TextBlock Name="textblockStatus" HorizontalAlignment="Left" Margin="145,172,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Height="49" Width="235"/>
    </Grid>
</Window>

'@

$reader=(New-Object System.Xml.XmlNodeReader $xaml) 
try{$syncHash.Window=[Windows.Markup.XamlReader]::Load( $reader )}
catch{Write-Host "Unable to load Windows.Markup.XamlReader. Some possible causes for this problem include: .NET Framework is missing PowerShell must be launched with PowerShell -sta, invalid XAML code was encountered."; exit}
$xaml.SelectNodes("//*[@Name]") | foreach {Set-Variable -Name ($_.Name) -Value $Form.FindName($_.Name)}


 # Run function run-iperf

function Run-Iperf 
{
param
(
[ValidateSet("1way","2way","simultan","all","test")]
[string] $Option)
    
# Variables
$cmd = 'C:\ProgramData\iperf\iperf.exe'
$server1 ='srv-iperf01.adm.huddinge.se'
$computer = '-c'
$2way = '-r'
$simultan = '-d'


switch ($Option)
{
    '1way' {
    write-host "Testar mot servern, det tar ca 10 sekunder"
    $stream = & $cmd $computer $server1 -y CSV;
    $csv = $stream -split ","
    $int = ($csv[7] -as [int]) / 1MB * 8 /10
    $result = "{0:N0}" -f $int
    $result
    
   
}
    '2way'{
    Write-Host "Testar mot servern, det tar ca 20 sekunder"

    $stream = & $cmd $computer $server1 $2way -y CSV
    $csv = $stream -split ","
    $int1 = ($csv[7] -as [int]) / 1MB * 8 /10
    $int2 = ($csv[16] -as [int]) / 1MB * 8 /10
    $result1 = "{0:N0}" -f $int1
    $result2 = "{0:N0}" -f $int2
    $result = $result1, $result2
    $result
}
    'simultan' {
   
    write-host "Testar mot servern, det tar ca 10 sekunder"
    $stream = & $cmd $computer $server1 $simultan -y CSV
    $csv = $stream -split ","
    $int1 = ($csv[7] -as [int]) / 1MB * 8 /10
    $int2 = ($csv[16] -as [int]) / 1MB * 8 /10
    $result1 = "{0:N0}" -f $int1
    $result2 = "{0:N0}" -f $int2
    $result = $result1, $result2
    $result
}
    'all' {
    write-host "Testar tvåväg mot servern, det tar ca 20 sekunder"
    $stream = & $cmd $computer $server1 $2way -y CSV
    $csv = $stream -split ","
    $int1 = ($csv[7] -as [int]) / 1MB * 8 /10
    $int2 = ($csv[16] -as [int]) / 1MB * 8 /10
    $result1 = "{0:N0}" -f $int1
    $result2 = "{0:N0}" -f $int2
    Write-Host " Testar simultan, det tar ca 10 sekunder"
    $stream2 = & $cmd $computer $server1 $simultan -y CSV
    $csv2 = $stream2 -split ","
    $int3 = ($csv2[7] -as [int]) / 1MB * 8 /10
    $int4 = ($csv2[16] -as [int]) / 1MB * 8 /10
    $result3 = "{0:N0}" -f $int3
    $result4 = "{0:N0}" -f $int4
   

}

   }
   
  }



$buttonStartamätning.add_click({ 

$option = $comboboxAlternativ.SelectedValue

$arg = ""

switch ($option)
{
    '1Väg' {$arg = "1way"}
    '2Väg' {$arg = "2way"}
    'Simultan' {$arg = "simultan"}
    Default {$arg = "1way"}
}

if ($option -eq '1väg')
{
$testfile = Invoke-Command -ComputerName $textboxDatornamn.Text -ScriptBlock {Test-Path -path "C:\ProgramData\iperf\iperf.exe"}

if ($testfile -eq $false)
{
    $texboxResult.Text = "Programmet iperf.exe finns inte katalogen C:\ProgramData\iperf\ var god lägg in det där innan du kör skriptet igen."
}
else
{
$result = Invoke-Command -ComputerName $textboxDatornamn.Text -ScriptBlock ${function:run-iperf} -ArgumentList $arg
$texboxResult.Text = "Ta emot filer $result MBit/s"
    
}


    
}

else
{
$testfile = Invoke-Command -ComputerName $textboxDatornamn.Text -ScriptBlock {Test-Path -path "C:\ProgramData\iperf\iperf.exe"}


$result = Invoke-Command -ComputerName $textboxDatornamn.Text -ScriptBlock ${function:run-iperf} -ArgumentList $arg

$res1 = $result[0]
$res2 = $result[1]

$texboxResult.Text = "Nedladdningshastighet $res1 MBit/s och uppladdningshastighet $res2 MBit/s"
    
}

 $syncHash.TextBox = $syncHash.window.FindName("texboxResult")
   

})
 $syncHash.Window.ShowDialog() | Out-Null
    $syncHash.Error = $Error

})


  
    

#$Form.ShowDialog() | out-null
$psCmd.Runspace = $newRunspace
$data = $psCmd.BeginInvoke()