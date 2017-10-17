$cred = Get-Credential

$scriptblock = {$gpoRules = Get-ItemProperty -Path Registry::HKLM\Software\Policies\Microsoft\WindowsFirewall\FirewallRules | Get-Member -MemberType NoteProperty
$localRules = Get-ItemProperty -Path Registry::HKLM\System\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules | Get-Member -MemberType NoteProperty
$allRules = $gpoRules + $localRules
$trimedRules = @()
    
    foreach ($rule in $allRules)
    {
        $trimedRules += [pscustomobject]@{
            "RuleName" = $rule.Name
            "RuleData" = $rule.Definition.TrimStart("System.String ")
            }
    }
        $Regler = @()
            foreach ($trimedRule in $trimedRules)
            {
                if ($trimedRule -like "*wmi*")
                {
                    $split = $trimedRule.ruledata.Split("|")
                        $ports = @()

                        foreach ($item in $split)
                        {
                            
                            if ($item -like "*RA4*")
                            {
                                $ports += $item.TrimStart("RA4")
                                $Regler += [pscustomobject]@{
                                    "Rule" = $trimedRule.rulename
                                    "Ports" = $ports
                                                            }
                            }
                                
                        }
                }
            
            
            }
        
    $regler
    }

    

   $test = Invoke-Command -ComputerName poc-wupapp01 -Credential $cred -ScriptBlock $scriptblock