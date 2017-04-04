# List ID, namn på variabel beskriver vilken lista
$toDoListId = "56fd2e1f68da4abe29f2b193"
$doingLisId = "56fd2e22f8e54dc4234f05b1"
$mötenListId = "589addc2ba22a665478258f0"
$sammanställningListId = "58a1aa9c242c0e1cd9b53936"

# API nyckel och Token(Viktors privata) behövs för att kunna skriva till tavlan.
$key = "9ccbd6f3620293e0c96f71d0041932d4"
$token = "a699562a3f3b6c55ab5c2fa1bf21a6d4ffb68a007e1f55f86e3656d4a4aa74cf"

# Hämta kort från respektive listor
$cardsInToDoList = invoke-restmethod "https://api.trello.com/1/lists/$($toDoListId)/cards"
$cardsInDoingList = invoke-restmethod "https://api.trello.com/1/lists/$($doingLisId)/cards"
$cardsInMötenList = invoke-restmethod "https://api.trello.com/1/lists/$($mötenListId)/cards"


# Lägg alla listor i samma variabel
$allCards = $cardsInToDoList + $cardsInDoingList + $cardsInMötenList

# Tom array för att fylla med resultat
$result = @()

# Sortera ut utförare, prognos, samt möte 
    
                    
    
    foreach ($card in $allCards)
    {
        
        
# Tömma variabler så det inte finns några rester        
        if ($prognos)
                    {
                    Remove-Variable -Name prognos
                    }

                    if ($user){
                    Remove-Variable -Name user
                    }

                    if ($möten){
                    Remove-Variable -Name möten
                    }
        
# Få ut alla labels i varibaler som i näste steg fylls till resultatvaribeln      
        $card.labels | ForEach-Object { 
            switch ($_.name)
            {
                {($_ -like "p*")} {$prognos = $_}
                {($_ -like "*Q*")} {$möten = $_}
                Default {$user += $_ + " "}
              
            }
            }
# Fylla på resultat arrayen med varibalerna från föregående steg           
            
            $result += [pscustomobject][ordered]@{
                'Ärende' = $card.name
                'Användare' = $user
                'Prognos' = if ($prognos) {$prognos.TrimStart("P")};
                'Möten' = if ($möten) {$möten.TrimStart("Q")};
          
                    }
                    
# Tömma variabler så inga rester finns kvar                
                    if ($prognos)
                    {
                    Remove-Variable -Name prognos
                    }

                    if ($user){
                    Remove-Variable -Name user
                    }
                    
                    if ($möten){
                    Remove-Variable -Name möten
                    }
}

# Tom array för att samla upp och summera all tid.
$usersAllTime = @()

# Räkna ut aktivitetstid och mötestid för alla användare
foreach ($user in ($result | Group-Object användare))
{
$aktiviteter = if ($user.Group.prognos) {($user.Group.prognos.replace(",",".") | Measure-Object -sum).sum} else { 0 }
$möten2 = if ($user.Group.möten) {$user.Group.möten.replace(",",".")} else { 0 }

$usersAllTime += [pscustomobject][ordered]@{
                
                'Användare' = $user.name
                'Aktiviteter' = $aktiviteter
                'Möten' = $möten2
                'sammanlagt' = [double]$möten2 + [double]$aktiviteter
          
                    }
    
}

$usersAllTime
# Töm listan Sammanställning på Trellotavlan
Invoke-RestMethod "https://api.trello.com/1/lists/$($sammanställningListId)/archiveAllCards/?key=$($key)&token=$($token)" -Method Post

# Skapa kort med aktivitetstid och mötestid för alla användare.
foreach ($item in $usersAllTime)
{
   $labelId = ""
    
    switch ($item.Användare)
    {
        {($_ -like "*Tony*")} { $labelId = "56fd2de2152c3f92fda38732" }
        {($_ -like "*Maria*")} { $labelId = "56fd3046152c3f92fda391e0" }
        {($_ -like "*Jimmy*")} { $labelId = "56fd2de2152c3f92fda38736" }
        {($_ -like "*Doone*")} { $labelId = "56fd2de2152c3f92fda38735" }
        {($_ -like "*Viktor*")} { $labelId = "56fd2de2152c3f92fda38734" }
    }
    $text = $item.Användare + " Aktiviteter:" + $item.Aktiviteter + " Möten:" + $item.Möten + " Sammanlagt:" + $item.sammanlagt
        $createCard = invoke-restmethod "https://api.trello.com/1/cards/?name=$($text)&idList=$($sammanställningListId)&key=$($key)&token=$($token)&idLabels=$($labelId)" -Method Post
       }



