$cmd = "C:\Program Files\iperf3\iperf3.exe"
$server = "huddp5132l2"
$computer = "-c"

$test = & $cmd $computer $server -J -f m | ConvertFrom-Json

[decimal]$bits = ($test.intervals.streams.bits_per_second | Measure-Object -Average).Average

[math]::Round($bits / 1MB)
