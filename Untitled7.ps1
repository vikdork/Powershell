# Variabler
$result = @()

# Samla in alla kort
$listDone = "56fd2e2a84d6ddf0cefc00e8"
$cardsInDoneList = invoke-restmethod "https://api.trello.com/1/lists/$($listDone)/cards"
    
# Sortera ut utförare och prognos sam utfall
    
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
      $result += [pscustomobject][ordered]@{
                'Ärende' = $card.name
                'Användare' = $user
                'Prognos' = $prognos
                'Utfall' = $utfall
                
                
                
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

$result