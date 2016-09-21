0<#

    Skapat Av: Markus Jakobsson 
               WWW.automatiserar.se 



#>
Add-Type -Assembly PresentationFramework            
Add-Type -Assembly PresentationCore
Add-Type –assemblyName WindowsBase

[xml]$xaml = @"

<Window 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Hyper-v  Creator" Height="395.819" Width="1030.273">
    <Grid>
        <Label x:Name="LabelHyperVHost" Content="LabelHyperVHost" HorizontalAlignment="Left" Margin="12,10,0,0" VerticalAlignment="Top"/>
        <TextBox x:Name="TextBoxGuestName" HorizontalAlignment="Left" Height="23" Margin="119,14,0,0" TextWrapping="Wrap" Text="TextBoxGuestName" VerticalAlignment="Top" Width="232"/>
        <ListBox x:Name="ListBoxGuestNames" HorizontalAlignment="Left" Height="163" Margin="550,10,0,0" VerticalAlignment="Top" Width="462"/>
        <Button x:Name="ButtonAddVmName" Content="ButtonAddVmName" HorizontalAlignment="Left" Margin="11,188,0,0" VerticalAlignment="Top" Width="506" Height="33"/>
        <Label x:Name="LabelIsoPath" Content="LabelIsoPath" HorizontalAlignment="Left" Margin="12,38,0,0" VerticalAlignment="Top"/>
        <TextBox x:Name="TextBoxIsoTextbox" HorizontalAlignment="Left" Height="23" Margin="119,41,0,0" TextWrapping="Wrap" Text="TextBoxIsoTextbox" VerticalAlignment="Top" Width="232"/>
        <Label x:Name="LabelMemory" Content="LabelMemory" HorizontalAlignment="Left" Margin="12,95,0,0" VerticalAlignment="Top"/>
        <Slider x:Name="SliderMemory" HorizontalAlignment="Left" Margin="119,98,0,0" VerticalAlignment="Top" Width="237" Minimum="1" Maximum="8" SmallChange="1"/>
        <Label x:Name="LabelCurrentMemory" Content="LabelCurrentMemory" HorizontalAlignment="Left" Margin="356,95,0,0" VerticalAlignment="Top"/>
        <Label x:Name="LabelDiskSize" Content="LabelDiskSize" HorizontalAlignment="Left" Margin="12,121,0,0" VerticalAlignment="Top"/>
        <Slider x:Name="SliderDisk" HorizontalAlignment="Left" Margin="119,121,0,0" VerticalAlignment="Top" Width="237" Minimum="20" Maximum="80" SmallChange="5" TickFrequency="5"/>
        <Label x:Name="LabelCurrentDiskSize" Content="LabelCurrentDiskSize" HorizontalAlignment="Left" Margin="357,120,0,0" VerticalAlignment="Top"/>
        <ComboBox x:Name="PickBoxLan" HorizontalAlignment="Left" Margin="119,151,0,0" VerticalAlignment="Top" Width="232"/>
        <Label x:Name="LabelLan" Content="LabelLan" HorizontalAlignment="Left" Margin="10,147,0,0" VerticalAlignment="Top" Width="102"/>
        <Label x:Name="LabelVMPath" Content="LabelVMPath" HorizontalAlignment="Left" Margin="12,69,0,0" VerticalAlignment="Top"/>
        <TextBox x:Name="TextBoxVmFilePath" HorizontalAlignment="Left" Height="23" Margin="119,69,0,0" TextWrapping="Wrap" Text="TextBoxVmFilePath" VerticalAlignment="Top" Width="232"/>
        <Button x:Name="ButtonCreateAllVMS" Content="ButtonCreateAllVMS" HorizontalAlignment="Left" Margin="550,188,0,0" VerticalAlignment="Top" Width="462" Height="33"/>
        <CheckBox x:Name="CheckBoxHyperVFolderOK" Content="CheckBoxHyperVFolderOK" HorizontalAlignment="Left" Margin="356,71,0,0" VerticalAlignment="Top"/>
        <CheckBox x:Name="CheckBoxIsoOK" Content="CheckBoxIsoOK" HorizontalAlignment="Left" Margin="357,44,0,0" VerticalAlignment="Top"/>
        <CheckBox x:Name="CheckBoxVMNameOK" Content="CheckBoxVMNameOK" HorizontalAlignment="Left" Margin="357,16,0,0" VerticalAlignment="Top"/>
    </Grid>
</Window>
"@

$reader=(New-Object System.Xml.XmlNodeReader $xaml)
$Window=[Windows.Markup.XamlReader]::Load( $reader )

# Pickbox
$PickBoxLan         = $Window.FindName("PickBoxLan")

# Listbox
$ListBoxGuestNames  = $Window.FindName("ListBoxGuestNames")

# Checkbox
$CheckBoxVMNameOK       = $Window.FindName("CheckBoxVMNameOK")
$CheckBoxHyperVFolderOK = $Window.FindName("CheckBoxHyperVFolderOK")
$CheckBoxIsoOK          = $Window.FindName("CheckBoxIsoOK")

# Sliders
$SliderMemory       = $Window.Findname("SliderMemory")
$SliderDisk         = $Window.FindName("SliderDisk")

# textbox
$TextBoxVmFilePath    = $Window.FindName("TextBoxVmFilePath")
$TextBoxGuestName     = $Window.FindName("TextBoxGuestName")
$TextBoxIsoTextbox    = $Window.FindName("TextBoxIsoTextbox")


# text
$LabelCurrentMemory   = $Window.FindName("LabelCurrentMemory")
$LabelCurrentDiskSize = $Window.FindName("LabelCurrentDiskSize")
$LabelHyperVHost      = $Window.FindName("LabelHyperVHost")
$LabelIsoPath         = $Window.FindName("LabelIsoPath")
$LabelLan             = $Window.FindName("LabelLan")
$LabelVMPath          = $Window.FindName("LabelVMPath")

# Knappar 
$ButtonAddVmName    = $Window.FindName("ButtonAddVmName")
$ButtonCreateAllVMS = $Window.FindName("ButtonCreateAllVMS")    



### Uppstartsvariabler 

    $LabelHyperVHost.content = "Guest Namn"
    $LabelIsoPath.content    = "Iso Path"
    $LabelLan.content        = "Lan Switch" 
    $LabelVMPath.content     = "VM Destination"

    # Tömmer Textbox
    $TextBoxGuestName.Text  = ""
    $TextBoxVmFilePath.text = "C:\VM"
    $TextBoxIsoTextbox.text = "C:\ISO\en_windows_server_2012_r2_vl_with_update_x64_dvd_4065221.iso"

    # skriver ut default info
    $LabelCurrentMemory.content = "{0} GB" -f ($SliderMemory.Value -as [int]) 
    $LabelCurrentDiskSize.content = "{0} GB" -f ($SliderDisk.Value -as [int])
    $ButtonAddVmName.Content = "Lägg Till VM i Listan"


    $PickBoxLan.SelectedIndex = 0  # sätter första objeket som default V-LAN

    # gömmer kontroller 
    $ButtonCreateAllVMS.Visibility = "hidden"
    


    # Kontrollerar om sökvägen finns.

    $CheckBoxVMNameOK.Content = "Namn OK"
    $CheckBoxVMNameOK.IsEnabled = $false

    $CheckBoxHyperVFolderOK.Content = "Sökväg OK"
    $CheckBoxHyperVFolderOK.IsEnabled = $false
    
    $CheckBoxIsoOK.Content = "ISO OK"
    $CheckBoxIsoOK.IsEnabled = $false 

### Testar om sökvägen till filerna finns.

function Test-AllPaths {


    if (Test-Path $TextBoxVmFilePath.Text){
        $CheckBoxHyperVFolderOK.IsChecked = $true
    } else {$CheckBoxHyperVFolderOK.IsChecked = $false}



    if ((Test-Path $TextBoxIsoTextbox.text) -and $($TextBoxIsoTextbox.Text -match '.iso')){
        $CheckBoxIsoOK.IsChecked = $true
    } else {$CheckBoxIsoOK.IsChecked = $false}



    if ($TextBoxGuestName.Text.Length -ge 4){
        if ((Get-VM -Name $TextBoxGuestName.Text -ErrorAction SilentlyContinue) -eq $null){
            $CheckBoxVMNameOK.IsChecked = $true
        } 
    } else {$CheckBoxVMNameOK.IsChecked = $false}
}
### Ladda in Hyper-V information 

Test-AllPaths

try{
    Import-Module hyper-v
}
catch{
    throw "Kunde inte ladda Hyper-v Modulen"
}

# Kontrollerar Hyper-V
if (!(Get-Module -Name Hyper-V)){throw "Saknar Hyper-V Modulen"} else {
    
        Get-VMSwitch | ForEach-Object {

            $PickBoxLan.items.add($_.NAME) | Out-Null
        }


    }

### Start

    

# Alla VMS adderas här
$VMarray = @()


$SliderMemory.add_ValueChanged({

    $LabelCurrentMemory.content = "{0} GB" -f ($SliderMemory.Value -as [int]) 


})

$SliderDisk.add_ValueChanged({

    $LabelCurrentDiskSize.content = "{0} GB" -f ($SliderDisk.Value -as [int])
})

$TextBoxGuestName.add_MouseLeave({ 
    
    Test-AllPaths

})

$TextBoxVmFilePath.add_MouseLeave({
    
    Test-AllPaths
})

$TextBoxIsoTextbox.add_MouseLeave({
    
    Test-AllPaths

})

# skapar alla VM:s
$ButtonCreateAllVMS.add_click({
    
    $ButtonCreateAllVMS.IsEnabled = $false    
    foreach ($VmToCreate in $VMarray){

        
        $newVM = New-VM -Name $VmToCreate.VmName -MemoryStartupBytes ([int]$VmToCreate.VMmemory * 1GB)  -NoVHD -SwitchName $VmToCreate.VMSwitch
        $newVhd = New-VHD -Path "$($VmToCreate.VMPath + "\" + $VmToCreate.vmname).VHDX" -SizeBytes $($VmToCreate.VMDisk * 1GB) -Dynamic 

        Add-VMHardDiskDrive -VMName $newvm.name -Path $newVhd.Path -ControllerNumber 0

        Set-VMDvdDrive -VMName $newvm.name -ControllerNumber 1 -Path $VmToCreate.vmIso


    }


    $ButtonCreateAllVMS.Content = "Skapade $($ListBoxGuestNames.items.count) Maskiner"

    $ListBoxGuestNames.Items.Clear() # tömmer allt
})

$ButtonAddVmName.add_click({
            
            $script:VMarray += New-Object psobject -Property @{
               
                      VmName = [string]$TextBoxGuestName.Text
                      VMIso  = [string]$TextBoxIsoTextbox.Text
                      VMPath = [string]$TextBoxVmFilePath.Text
                      VMMemory = [int]$SliderMemory.Value
                      VMDisk   = [int]$SliderDisk.Value
                      VMSwitch = [string]$PickBoxLan.SelectedItem
            }

            $TextBoxGuestName.text = ""

            $ListBoxGuestNames.items.clear()
            foreach ($vm in $VMarray){

            $ListBoxGuestNames.items.add($vm.VmName)


            }
            
            if ($ListBoxGuestNames.Items.Count -ge 1){
            $ButtonCreateAllVMS.Visibility = "visible"

            $ButtonCreateAllVMS.IsEnabled = $true 
            $ButtonCreateAllVMS.Content   = "Skapa $($ListBoxGuestNames.items.count) VM:s"
            Test-AllPaths
            }
})



$Window.ShowDialog() | Out-Null


