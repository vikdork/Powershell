<#

Så här ska CVS se ut.
Job;Source;Target;Replace;Result
KSF01;N:\Groups\KS\ADMINISTRATIVA AVDELNINGEN;\\srv-fil05\Gemensam$\KSF\Administration och nämnd\Administrativa avdelningen;1;\\srv-fil05\Gemensam$\KSF\Administration och nämnd\Administrativa avdelningen
KSF54;N:\Groups\KS\KS KANSLI;\\srv-fil05\Gemensam$\KSF\Administration och nämnd\Administrativa avdelningen;0;\\srv-fil05\Gemensam$\KSF\Administration och nämnd\Administrativa avdelningen\KS Kansli
KSF02;N:\Groups\KS\BLANKETTER;\\srv-fil05\Gemensam$\KSF\Kommunikation;0;\\srv-fil05\Gemensam$\KSF\Kommunikation\Blanketter
KSF03;N:\Groups\KS\CHEFSDAG 2011;\\srv-fil05\Gemensam$\KSF\Kommunikation;0;\\srv-fil05\Gemensam$\KSF\Kommunikation\Chefsdag 2011
KSF04;N:\Groups\KS\CMS-SERVER;\\srv-fil05\Gemensam$\KSF\Kommunikation;0;\\srv-fil05\Gemensam$\KSF\Kommunikation\CMS-server
KSF05;N:\Groups\KS\E-FÖRVALTNING;\\srv-fil05\Gemensam$\KSF\Administration och nämnd\Administrativa avdelningen\IT-sektionen;0;\\srv-fil05\Gemensam$\KSF\Administration och nämnd\Administrativa avdelningen\IT-sektionen\E-förvaltning
KSF06;N:\Groups\KS\EKONOMIKONTORET;\\srv-fil05\Gemensam$\KSF\Ekonomi;1;\\srv-fil05\Gemensam$\KSF\Ekonomi

#>

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
