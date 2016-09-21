Measure-Command{
$maximum = 11
$minimum = 1

$result = ""
$result = @()

for ($i = 0; $i -lt 20000; $i++)
{ 
     $SONNY = Get-Random -Minimum $minimum -Maximum $maximum
     $result + 

   }
   
 #  $result <# | Group-Object | Sort-Object count | select count, name | ft #>
   }

   switch ($x)
   {
       'value1' {}
       {$_ -in 'A','B','C'} {}
       'value3' {}
       Default {}
   }