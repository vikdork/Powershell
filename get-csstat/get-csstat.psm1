###########################################
#get-csstat.psm1
#Get your Counter Strike GO player stats
###########################################


function get-csstat{ 
<#
 
.SYNOPSIS
This module get Counter-strike GO player stats for players in the poisonous Purple Snake clan.
 
.DESCRIPTION
The connect to steam web api and collect the latest data. It displays stats on the screen and exports a csv named [spelare].txt and place the file in your homedirectory
 
.EXAMPLE
get-csstat -spelare viktor
 
.NOTES
Would love for steam to create a better api
 
.LINK
 
http://https://www.facebook.com/groups/503693329739322/?fref=ts
Don`t spread this, it´s my personal api key.
 
#>

param(
[parameter(mandatory)]
[ValidateSet("viktor","Magnus","anton","pelle","daniel","stefan")]
[string]$spelare)

#$id = import-csv C:\temp\cs.txt | where name -eq "$spelare"
$test = @{"viktor"="76561197962555828";"Magnus"="76561198045332968";"anton"="76561198001082744";"pelle"="76561198044973893";"daniel"="76561198002284708";"stefan"="76561198010446916"}
$steamid = $test.$spelare
 $stat = Invoke-WebRequest "http://api.steampowered.com/ISteamUserStats/GetUserStatsForGame/v0002/?appid=730&key=A9872F0CCE4E96D920A7ADEF680A26DE&steamid=$steamid=&format=json" | ConvertFrom-Json 
$stat.playerstats.stats
$stat.playerstats.stats | export-csv $home\$spelare.txt -NoTypeInformation 
}
