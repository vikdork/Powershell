﻿<#

.SYNOPSIS

Få reda på och exportera vilka medlemmar en AD-grupp har.



.DESCRIPTION

Kör skriptet och fyll grupp, applikationen kollar så att gruppen finns i AD:et annars går det inte att söka. Vid export bockar man i vilka attribut 
man vill exportera och trycker på exportknappen, det skapas då en fil under c:\temp som heter resultat[timme.minut.sekund].csv tex c:\temp\resultat10.30.21.csv.

.NOTES
Made by: Viktor Lindström
http://powerhell.nu
Version 1.0 fyll på med förändringar här under.
#>

#build GUI

[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')

[xml]$XAML = @'

<Window 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Medlemmar i AD-grupp" Height="350" Width="687.807">
    <Grid>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="258*"/>
            <ColumnDefinition Width="259*"/>
        </Grid.ColumnDefinitions>
        <TextBox Name="textBox" HorizontalAlignment="Left" Height="23" Margin="99,28,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="230"/>
        <Label Name="LabelGruppnamn" Content="Gruppnamn:" HorizontalAlignment="Left" Margin="10,25,0,0" VerticalAlignment="Top" Width="76" RenderTransformOrigin="0.005,0.483"/>
        <ListBox Name="ListboxResult" Grid.Column="1" HorizontalAlignment="Left" Height="202" Margin="32,70,0,0" VerticalAlignment="Top" Width="279"/>
        <Button Name="ButtonSearch" Content="Lista användare" HorizontalAlignment="Left" Margin="99,70,0,0" VerticalAlignment="Top" Width="230" Height="35"/>
        <Label Name="LabelAnvändare" Content="Användare i gruppen:" Grid.Column="1" HorizontalAlignment="Left" Margin="185,25,0,0" VerticalAlignment="Top" Width="126"/>
        <CheckBox Name="checkBoxAnvändarnamn" Content="Användarnamn" HorizontalAlignment="Left" Margin="99,143,0,0" VerticalAlignment="Top" Width="240"/>
        <CheckBox Name="checkBoxNamn" Content="Namn" HorizontalAlignment="Left" Margin="99,169,0,0" VerticalAlignment="Top" Width="240"/>
        <CheckBox Name="checkBoxMail" Content="E-mailadress" HorizontalAlignment="Left" Margin="99,195,0,0" VerticalAlignment="Top" Width="240"/>
        <Label Name="labelExport" Content="Vad ska exporteras?" HorizontalAlignment="Left" Margin="10,117,0,0" VerticalAlignment="Top" Width="116"/>
        <Button Name="buttonExport" Content="Exportera" HorizontalAlignment="Left" Margin="99,230,0,0" VerticalAlignment="Top" Width="230" Height="31"/>
        <CheckBox Name="checkboxGruppnamn" Content="Grupp finns?" Grid.Column="1" HorizontalAlignment="Left" Margin="32,31,0,0" VerticalAlignment="Top"/>
        <Label Name="labelExport1" Content="" HorizontalAlignment="Left" Margin="10,279,0,0" VerticalAlignment="Top" Width="319"/>

    </Grid>
</Window>


'@

$reader=(New-Object System.Xml.XmlNodeReader $xaml) 
try{$Form=[Windows.Markup.XamlReader]::Load( $reader )}
catch{Write-Host "Unable to load Windows.Markup.XamlReader. Some possible causes for this problem include: .NET Framework is missing PowerShell must be launched with PowerShell -sta, invalid XAML code was encountered."; exit}
$xaml.SelectNodes("//*[@Name]") | foreach {Set-Variable -Name ($_.Name) -Value $Form.FindName($_.Name)}

# Global variable for result
$resultArray = @()

# Disable button by default
$ButtonSearch.IsEnabled = $false


# Funtion to test if AD-group exists.
function Test-Group 
{

if ((Get-ADGroup -Filter {SamAccountName -eq $textBox.Text}) -ne $null)
{$checkboxGruppnamn.IsChecked = $true
  $ButtonSearch.IsEnabled = $true} else {$checkboxGruppnamn.IsChecked = $false
  $ButtonSearch.IsEnabled = $false}
    }

# Searchbutton, gets all memebers of the group specified in the textbox, puts result in $resultarray
$ButtonSearch.add_click({
    $script:resultArray = @()
    $ListboxResult.Items.Clear()
    $allMembers = Get-ADGroupMember -Identity $textBox.Text
    $members = $allMembers | Where-Object {$_.objectClass -eq "user"}
    $groups = $allMembers | Where-Object {$_.objectClass -eq "group"}

    
        foreach ($item in $members)
        {
         $member = Get-ADObject -Identity $item -Properties mail, displayname, samaccountname | Select-Object samaccountname, mail, displayname
         $ListboxResult.Items.Add($member.displayname)
         $script:resultArray += $member
        }
          foreach ($group in $groups)
          {
              $ListboxResult.Items.Add($group.name)
              $script:resultArray += $group | Select-Object name
          }
                        })

# Exportbutton, exports attributes that has been checked in the checkboxes, exports to an CSV-file c:\temp\resultat[HH.mm.ss].csv to uniq it.
                $buttonExport.add_click({
                $export = @()
                
                $date = get-date -Format HH.mm.ss
                $exportdate =  "c:\temp\resultat$date.csv"
                if (Test-Path $exportdate) {Remove-Item $exportdate}

                    foreach ($object in $resultArray)
                    {
                     $export += New-Object psobject -Property @{
               
                      "Användarnamn" = if ($checkBoxAnvändarnamn.IsChecked -eq $true) {$object.samaccountname};
                      "Namn" = if ($checkBoxNamn.IsChecked -eq $true) {$object.displayname};
                      "E-mailadress" = if ($checkBoxMail.IsChecked -eq $true) {$object.mail};
                    }
                    }

                    $export | Export-Csv $exportdate -NoTypeInformation -Encoding UTF8 -Delimiter ";"
                    $labelExport1.Content = "Export klar, filen hittar du här: $exportdate"
                    

                    
                 })
# Runs the AD-test group function in realtime as you write in the textbox.
$textBox.add_Keyup({ 
    
    Test-Group
})

$Form.ShowDialog() | out-null