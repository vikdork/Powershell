$a = "a","b","a","c","a","d"
$test = "" | select "hej", "hopp"

foreach ($item in $a)
  {
  if ($item -eq "a")
  {$test.hej = $item
      
  }
  else 
  {$test.hopp = $item
  }
                        
                if ($test.hej -ne $null -And $test.hopp -ne $null)
                { 
              
                $test | export-csv temp.txt -Append -NoTypeInformation -Encoding UTF8 
                $test.hej = $null
                $test.hopp = $null
                
                    
                    
                               }

                               }
                                


