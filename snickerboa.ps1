<#

.SYNOPSIS

Lägga till och ta bort användare i en grupp



.DESCRIPTION



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
        Title="Snickerboa" Height="350" Width="525">
    <Grid>
        <TextBox Name="textBoxAnvändarenamn" HorizontalAlignment="Left" Height="23" Margin="130,46,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="120"/>
        <Label Name="labelAnvändarnamn" Content="Anändarnamn:" HorizontalAlignment="Left" Margin="25,43,0,0" VerticalAlignment="Top" Width="92"/>
        <Button Name="buttonLäggtill" Content="Lägg till" HorizontalAlignment="Left" Margin="33,86,0,0" VerticalAlignment="Top" Width="75"/>
        <Button Name="buttonTaBort" Content="Ta Bort" HorizontalAlignment="Left" Margin="33,125,0,0" VerticalAlignment="Top" Width="75"/>
        <ListBox Name="listBoxAnvändare" HorizontalAlignment="Left" Height="254" Margin="294,46,0,0" VerticalAlignment="Top" Width="205"/>
        <Label Name="labelResult" Content="" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="25,214,0,0" Height="86" Width="252"/>

    </Grid>
</Window>



'@

$reader=(New-Object System.Xml.XmlNodeReader $xaml) 
try{$Form=[Windows.Markup.XamlReader]::Load( $reader )}
catch{Write-Host "Unable to load Windows.Markup.XamlReader. Some possible causes for this problem include: .NET Framework is missing PowerShell must be launched with PowerShell -sta, invalid XAML code was encountered."; exit}
$xaml.SelectNodes("//*[@Name]") | foreach {Set-Variable -Name ($_.Name) -Value $Form.FindName($_.Name)}
    
    $adGroup = "Elev test grupp"
    
    #populera listboxen
          $allMembers = Get-ADGroupMember -Identity $adGroup
          foreach ($members in $allMembers)
          {
              $listBoxAnvändare.Items.Add($members.name)
          }

            $buttonLäggtill.add_click({
                
                $user = Get-ADUser -Identity $textBoxAnvändarenamn.Text
                $group = Get-ADGroup $adGroup
                Add-ADGroupMember $group -Members $user
                $listBoxAnvändare.items.clear()
                  
                  $allMembers = Get-ADGroupMember -Identity $adGroup
                        foreach ($members in $allMembers)
                            {
                                $listBoxAnvändare.Items.Add($members.name)
                            }
                
                $labelResult.Content = "Användaren $($user.name) har ränt till sncikerboa"   
                    
                    $buttonTaBort.add_click({
                        
                        $user = Get-ADUser -Identity $textBoxAnvändarenamn.Text
                        $group = Get-ADGroup $adGroup
                        Remove-ADGroupMember -Identity $group -Members $user
                        $listBoxAnvändare.items.clear()
                  
                  $allMembers = Get-ADGroupMember -Identity $adGroup
                        foreach ($members in $allMembers)
                            {
                                $listBoxAnvändare.Items.Add($members.name)
                            }
                
                $labelResult.Content = "Användaren $($user.name) har gått ur sncikerboa $($group.name)" 
                        
                    })  
                
            })


$Form.ShowDialog() | out-null