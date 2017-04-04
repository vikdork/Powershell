# API nyckel och Token(Viktors privata) behövs för att kunna skriva till tavlan.
$key = "9ccbd6f3620293e0c96f71d0041932d4"
$token = "a699562a3f3b6c55ab5c2fa1bf21a6d4ffb68a007e1f55f86e3656d4a4aa74cf"

# Variabler
$result = @()

# Samla in alla kort från klarlistan
$listDone = "56fd2e2a84d6ddf0cefc00e8"
$cardsInDoneList = invoke-restmethod "https://api.trello.com/1/lists/$($listDone)/cards"
    
# Sortera ut utförare, prognos, ärende samt utfall
    
    foreach ($card in $cardsInDoneList)
    {
        $card.labels | ForEach-Object { 
            switch ($_.name)
            {
                {($_ -like "u*")} {$utfall = $_}
                {($_ -like "p*")} {$prognos = $_}
                Default {$user += $_ + " "}
              
            }
                                      }  

# Samla ihop resultatet i ett object.
      $result += [pscustomobject][ordered]@{
                'Ärende' = $card.name
                'Användare' = $user
                'Prognos' = $prognos.TrimStart("P")
                'Utfall' = if ($utfall) {$utfall.TrimStart("U")} else {$prognos.TrimStart("P")}
                    }
                    if ($utfall)
                    {
                        Remove-Variable -Name utfall
                    }
                
                    if ($prognos)
                    {
                    Remove-Variable -Name prognos
                    }

                    if ($user){
                    Remove-Variable -Name user
                    }
    }
    # Töm listan "Done" på Trellotavlan
Invoke-RestMethod "https://api.trello.com/1/lists/$($listDone)/archiveAllCards/?key=$($key)&token=$($token)" -Method Post

$result
$result | export-csv c:\temp\trello.csv -NoTypeInformation -Delimiter ";" -Encoding UTF8 -Append