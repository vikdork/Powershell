$maximum = 20
$minimum = 1

$maxMini = $maximum..$minimum
$allvar = @()

foreach ($item in $maxMini)
{
$name = "$" + $item
    Set-Variable -Name $item -Value $item -Visibility Public

    $allvar += $name
}

