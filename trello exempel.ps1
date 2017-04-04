$boardId = "56fd2de2687bad52ab3fe662"
$listDone = "56fd2e2a84d6ddf0cefc00e8"
$key = "9ccbd6f3620293e0c96f71d0041932d4"
$token = "a699562a3f3b6c55ab5c2fa1bf21a6d4ffb68a007e1f55f86e3656d4a4aa74cf"
$oAuth = "b72f879ff4b69b08d806435990cd86268287a75a5addcf27f4a6094d4b1d3653"


$hej = "https://api.trello.com/1/lists/$($listId)lists=open&cards=open"

$board = invoke-restmethod "https://api.trello.com/1/boards/$($boardId)?lists=open&cards=open"
$board


##
$cardsInDoneList = invoke-restmethod "https://api.trello.com/1/lists/$($listDone)/cards"




$createCard = invoke-restmethod "https://api.trello.com/1/cards/?name=Arsbessstsplats&idList=$($listDone)&key=$($key)&token=$($token)&idLabels=56fd2de2152c3f92fda38734" -Method Post

$test = ($board.cards) | where name -EQ "Grundrigga server i FIM testmiljö för ADLDS"