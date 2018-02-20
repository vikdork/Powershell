# Installera azurestoragemodul, behövs bara  1 gång per dator.
#Install-Module AzureRmStorageTable
Import-Module AzureRmStorageTable

    
        #Loginuppgifter samt logga in mot azure samt välj subscription.
        $subscriptionName = "betala per användning"
        $PWord = ConvertTo-SecureString -String "Erv!23Wer!" -AsPlainText -Force
        $user = "emoitionapp@viktorlindstromoutlook.onmicrosoft.com"
        $Credential = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $User, $PWord
        Add-AzureRmAccount -Credential $Credential
        Select-AzureRmSubscription -SubscriptionName $subscriptionName
            
            #importera azure storagemodulen.
            Import-Module azureRmStorageTable

            #Variabler för azure.
            $resourceGroup = "emotions"
            $storageAccount = "emotionshuddingeit"
            $tableName = "Emoitions"
            $partitionKey = "000000001"
                
                #Sätt "Context" vissa operations behöver det. 
                $saContext = (Get-AzureRmStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccount).Context

                    #Hämta tabellen
                    $table = Get-AzureStorageTable -Name $tableName -Context $saContext

                        #Hämta alla rader
                        $allDatabaserows = Get-AzureStorageTableRowAll -table $table

                        $sixDaysAgoDate = (get-date).AddDays(-6)
                        $fiveDaysAgoDate = (get-date).AddDays(-5)
                        $fourDaysAgoDate = (get-date).AddDays(-4)
                        $threeDaysAgoDate = (get-date).AddDays(-3)
                        $twoDaysAgoDate = (get-date).AddDays(-2)
                        $oneDaysAgoDate = (get-date).AddDays(-1)

                        $allDays = $sixDaysAgoDate, $fiveDaysAgoDate, $fourDaysAgoDate, $threeDaysAgoDate, $twoDaysAgoDate 
                      
                        $Global:resultDay = @()
                        $resultWeek = @()
                        function get-MniStats
                        {
                                 param ( $fromDate,
                                         $toDate)


                              $oldDate = Get-Date -Date $fromDate
                              $newDate = Get-Date -Date $todate    
                              
                              $rowsWithinDates = $allDatabaserows | Where-Object {$_.TableTimestamp -gt $oldDate -and $_.TableTimestamp -lt $newDate}
                              
                              foreach ($oneDay in $rowsWithinDates)
                              {
                                  
                                   
                                        $Global:resultDay += [pscustomobject]@{
                                            "Dag" = $oneDay.TableTimestamp.DayOfWeek
                                            "Datum" = $oneDay.TableTimestamp.Date.GetDateTimeFormats()[0]
                                            "Poang" = $oneDay.Emotion 
                                            
                                                                    }
                                                     

                              }
                              }


                              $test[1].group.poang | Measure-Object -Average
                        