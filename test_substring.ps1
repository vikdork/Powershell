$list = @"
1 Partridge in a pear tree
2 Turtle Doves
3 French Hens
4 Calling Birds
5 Golden Rings
6 Geese a laying
7 Swans a swimming
8 Maids a milking
9 Ladies dancing
10 Lords a leaping
11 Pipers piping
12 Drummers drumming
"@

$split = $list.Split("`n")

$sortedCollectionNoNums = $list.split("`n") | foreach-object { $_.substring($_.indexof(' ') + 1) } | sort-object -property length


$viktor = "Viktor"