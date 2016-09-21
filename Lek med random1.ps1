Measure-Command {

$maximum = 101
$minimum = 1

$maxMini = $maximum..$minimum



$result = ""
$result = @()

$1 = 0
$2 = 0
$3 = 0
$4 = 0
$5 = 0
$6 = 0
$7 = 0
$8 = 0
$9 = 0
$10 = 0

for ($i = 0; $i -lt 20000; $i++)
{ 
    $random = Get-Random -Minimum $minimum -Maximum $maximum
    #Write-Host $i

    switch ($random.ToString())
    {
       "1" {$1++}
       "2" {$2++}
       "3" {$3++}
       "4" {$4++}
       "5" {$5++}
       "6" {$6++}
       "7" {$7++}
       "8" {$8++}
       "9" {$9++}
       "10" {$10++}
    }
    }
$result += New-Object psobject -Property @{
    1 = $1
    2 = $2
    3 = $3
    4 = $4
    5 = $5
    6 = $6
    7 = $7
    8 = $8
    9 = $9
    10 = $10
    }
$result
    }