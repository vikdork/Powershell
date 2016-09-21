[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')

[xml]$XAML = @'

<Window
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="ADaddtogroup" Height="379" Width="462">
    <Grid x:Name="labelGroup">
        <Label Name="labelUser" Content="User:" HorizontalAlignment="Left" Margin="1,21,0,0" VerticalAlignment="Top" Width="51"/>
        <Label Name="labelGroup1" Content="Group:" HorizontalAlignment="Left" Margin="1,52,0,0" VerticalAlignment="Top" Width="51"/>
        <TextBox Name="textboxUser" HorizontalAlignment="Left" Height="23" Margin="85,25,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="120" RenderTransformOrigin="0.392,-0.391"/>
        <TextBox Name="textboxGroup" HorizontalAlignment="Left" Height="23" Margin="85,56,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="120" RenderTransformOrigin="0.392,-0.391"/>
        <CheckBox Name="CheckboxUser" Content="Users exists?" HorizontalAlignment="Left" Margin="223,27,0,0" VerticalAlignment="Top"/>
        <CheckBox Name="checkboxGroup" Content="Group exists?" HorizontalAlignment="Left" Margin="223,58,0,0" VerticalAlignment="Top" RenderTransformOrigin="0.07,0.867"/>
        <Label Name="labelDate" Content="Remove date:" HorizontalAlignment="Left" Margin="1,84,0,0" VerticalAlignment="Top" Width="100"/>
        <TextBox Name="texboxDate" HorizontalAlignment="Left" Height="23" Margin="85,87,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="120" RenderTransformOrigin="0.392,-0.391"/>
        <Label Name="labelDate1" Content="Date format: YYYY-MM-DD(2015-04-24)" HorizontalAlignment="Left" Margin="223,87,0,0" VerticalAlignment="Top" Width="224"/>
        <Button Name="buttonAdd" Content="Add" HorizontalAlignment="Left" Margin="75,163,0,0" VerticalAlignment="Top" Width="75"/>
        <Button Name="ButtonCancel" Content="Cancel" HorizontalAlignment="Left" Margin="341,163,0,0" VerticalAlignment="Top" Width="75"/>
        <TextBox Name="labelResult" HorizontalAlignment="Left" Height="103" Margin="75,204,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="341"/>
        <CheckBox Name="checkboxDisable" Content="Disable Account?" HorizontalAlignment="Left" Margin="75,126,0,0" VerticalAlignment="Top"/>
    </Grid>
</Window>
'@

$reader=(New-Object System.Xml.XmlNodeReader $xaml) 
try{$Form=[Windows.Markup.XamlReader]::Load( $reader )}
catch{Write-Host "Unable to load Windows.Markup.XamlReader. Some possible causes for this problem include: .NET Framework is missing PowerShell must be launched with PowerShell -sta, invalid XAML code was encountered."; exit}
$xaml.SelectNodes("//*[@Name]") | foreach {Set-Variable -Name ($_.Name) -Value $Form.FindName($_.Name)}


#checkboxar
$CheckboxUser.IsEnabled = $false
$CheckboxGroup.IsEnabled = $false

#fill in today date
$date = get-date -Format yyyy-MM-dd
$texboxDate.Text = $date  

#function to test user and group

function test-usergroup
{ 
if ($textboxUser.Text -eq "$null")
{}
elseif
((get-aduser -Filter {SamAccountName -eq $textboxUser.Text})) 
   {
$CheckboxUser.IsChecked = $true}
else {$CheckboxUser.IsChecked = $false
    }

if ($textboxGroup.Text -eq "$null")
{}
elseif
((get-adgroup -Filter {Name -eq $textboxGroup.Text})) {
$CheckboxGroup.IsChecked = $true}
else {$CheckboxGroup.IsChecked = $false
}
    }
$textboxUser.add_KeyUp({ 
    
    test-usergroup
})

$textboxGroup.add_KeyUp({

test-usergroup

})

$ButtonCancel.Add_click({
$textboxUser.Clear()
$textboxGroup.Clear()
$CheckboxGroup.IsChecked = $false
$CheckboxUser.IsChecked = $false
})

$Form.ShowDialog() | out-null
