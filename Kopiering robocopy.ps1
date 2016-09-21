$logruntime = get-date -Format yyMMdd_HHmm

new-item -type directory "N:\robocopy_log\$logruntime"

$import = Import-Csv -path C:\test\Gemensam.csv -Delimiter ';'

Foreach ($line in $import)
        {
      $source = $line | select -ExpandProperty source
      $result = $line | select -ExpandProperty result
      $job = $line | select -ExpandProperty job
      $logpath = "N:\robocopy_log\$logruntime\$job.log"

              & robocopy $source $result /B /e /COPYALL /R:0 /W:0 /LOG:$logpath

              $logsum = (Get-Content -path $logpath | select-object -last 12)
              Add-Content -Path "N:\robocopy_log\RoboCopyLogSum_$logruntime.log" "$job $logsum `n"

                             } 
