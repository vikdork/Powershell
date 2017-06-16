[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')

[xml]$XAML = @'
<Window 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        Title="MainWindow" Height="350" Width="600">
    <Grid>
        <Label Name="labelAnvändarnamn" Content="Användarnamn:" HorizontalAlignment="Left" Margin="21,27,0,0" VerticalAlignment="Top" Width="95"/>
        <TextBox Name="textBoxAnvändarnNamn" HorizontalAlignment="Left" Height="23" Margin="121,31,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="71"/>
        <Button Name="buttonOk" Content="Ok!" HorizontalAlignment="Left" Margin="21,78,0,0" VerticalAlignment="Top" Width="171" Height="38"/>
        <ListBox Name="listBoxResult" HorizontalAlignment="Left" Height="273" Margin="279,31,0,0" VerticalAlignment="Top" Width="270"/>
        <Button Name="buttonCopy" Content="Kopiera Enhets ID" HorizontalAlignment="Left" Margin="21,149,0,0" VerticalAlignment="Top" Width="171" Height="37"/>

    </Grid>
</Window>

'@

$reader=(New-Object System.Xml.XmlNodeReader $xaml) 
try{$Form=[Windows.Markup.XamlReader]::Load( $reader )}
catch{Write-Host "Unable to load Windows.Markup.XamlReader. Some possible causes for this problem include: .NET Framework is missing PowerShell must be launched with PowerShell -sta, invalid XAML code was encountered."; exit}
$xaml.SelectNodes("//*[@Name]") | foreach {Set-Variable -Name ($_.Name) -Value $Form.FindName($_.Name)}
    
        #Function för att bygga Body med alla devicer som man vill bulkfråga i korrekt format.
        Function Set-DeviceListJSON {

	    param([array]$deviceIDs)

	    # $deviceIDs = @($device01, $device02, $device03)
	    $quoteCharacter = [char]34
	    $Global:bulkRequestObject = "{ " + $quoteCharacter + "BulkValues" + $quoteCharacter + ":{ " + $quoteCharacter + "Value" + $quoteCharacter + ": ["
	    foreach ($deviceID in $deviceIDs) {
		    $bulkRequestObject = $bulkRequestObject + $quoteCharacter + $deviceID + $quoteCharacter + ", "
	    }
	    [int]$stringLength = $bulkRequestObject.Length
	    [int]$lengthToLastComma = $stringLength - 2
	    $bulkRequestObject = $bulkRequestObject.Substring(0, $lengthToLastComma)
	    $bulkRequestObject = $bulkRequestObject + " ] }}"
	    Return $bulkRequestObject
   
    }
            # Funktion för att bygga en korrekt header för authentiseringen mot API:t
            Function Get-BasicUserForAuth {

	            Param([string]$userPlusPass)

	
	            $encoding = [System.Text.Encoding]::ASCII.GetBytes($userPlusPass)
	            $encodedString = [Convert]::ToBase64String($encoding)

	            Return "Basic " + $encodedString
            }
                #Variabler för användarnamn lösenord och tenant code.
                $Username = "MeetingsAPI"
                $Password = "kallebanan01"
                $APIkey = "YNF9Pz9Frh2C1OKBQEDeEDzojC31sgxalHOa4zTGVXg="

                # Skapa header för authentisering och säga till att man vill ha jsaon tillbaka
                $header = @{"Authorization" = (Get-BasicUserForAuth ($Username + ":" + $Password)); "aw-tenant-code" = $APIkey; "Accept" = "application/json"; "Content-Type" = "application/json"}

                    #API endpoints
                    $hostUrlTestSmartGroup = "https://cn137.awmdm.com/api/mdm/smartgroups/107347"
                    $hostUrlBulkDevice =  "https://cn137.awmdm.com/api/mdm/devices/id"
                    
                    #Kosmetik för att göra så pil blir till hand när man hovrar över någon av knapparna
                    $buttonOk.Add_MouseEnter({
                       $form.Cursor = [System.Windows.Input.Cursors]::Hand
                    })

                    $buttonOk.ADD_MouseLeave({
                        $form.Cursor = [System.Windows.Input.Cursor]::Arrow
                        })
                        $buttonCopy.Add_MouseEnter({
                           $form.Cursor = [System.Windows.Input.Cursors]::Hand
                        })

                        $buttonCopy.ADD_MouseLeave({
                            $form.Cursor = [System.Windows.Input.Cursor]::Arrow
                            })

                $buttonOK.Add_Click({
                        
                        $ListboxResult.Items.Clear()
                        $webRequestsmartGroups = Invoke-WebRequest -Uri $hostUrlTestSmartGroup -Headers $header -Method GET
                        $bulkDevice = ((Invoke-WebRequest -Uri $hostUrlBulkDevice -Headers $header -Method Post -Body (Set-DeviceListJSON -deviceIDs (($webRequestsmartGroups.Content | ConvertFrom-Json).deviceAdditions).Id)).content | ConvertFrom-Json).devices | Sort-Object AssetNumber -Unique | Where-Object "UserName" -EQ $textBoxAnvändarnNamn.Text
                            
                            foreach ($device in $bulkDevice)
                            {
                                $listBoxResult.Items.Add($device.Assetnumber)
                            }
                            
                            
                    })
                    
                    $buttonCopy.Add_Click({
                        [System.Windows.Forms.Clipboard]::SetText($listBoxResult.SelectedItem.Tostring())
                    })  



$Form.ShowDialog() | out-null