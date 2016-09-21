$watchGuard = Invoke-WebRequest -Uri "http://reputationauthority.org/lookup?ip=94.127.33.47"

$hej = ((($watchGuard.Content -split [Environment]::NewLine | Select-String -Pattern '/100') -split '<td class="bsnDataRow2" style="background-color:#EEEEEE;">') -split '/100')[1]

