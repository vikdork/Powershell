$server = "ping.sunet.se"
$ms = 10

for ($i = 1; $i -lt 9999; $i++)
{ 
#Start-Sleep -Seconds 1
$date = Get-Date
    $test = Test-Connection -ComputerName $server -Count 1

        if ($test.ResponseTime -gt $ms)
        {
         "time=" + $test.ResponseTime.ToString() + " ms " + $date | Out-File -FilePath c:\temp\ping.txt -Append
        }
}

