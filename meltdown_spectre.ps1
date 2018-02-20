function Get-SpecMelStatus
{
<#
.SYNOPSIS
   Skript för att kolla om man har skydd för Spectre och Meltdown
.DESCRIPTION
   Skriptet kollar om man har skydd mot meltdown och Spectre. Det använder sig av micrsofts verktyg för att verifiera om systemet är säkert eller osäkert: https://www.powershellgallery.com/packages/SpeculationControl/1.0.4
   Kör skriptet först för att ladda in funktionen sen kör man det som i exemplen här under. Man måste autentisera sig med ett konto som har administrativa rättigehter på destinationsdatorn
.EXAMPLE
   Get-specMelStatus -computers huddp5132l2
.EXAMPLE
   Get-specMelStatus -computers huddp5132l2, test-viktor01
#>

    [CmdletBinding()]
    Param
            
            ([Parameter(Mandatory=$true,
              ValueFromPipelineByPropertyName=$true,
              Position=0)]
              $Computers            )        #Fult med uppmappningen gör om med double hop cred eller uppmappning i scriptblock.    $cred = Get-Credential -Message "Konto som har admin på fjärrdatorn"    $Global:resultat = @()            foreach ($compName in $Computers)
    {
                #Mappa upp c:\temp på destinationsdatron för att kopiera över PS-scripten.        New-PSDrive -Name $compName -PSProvider FileSystem -Root ("\\" + $compName + "\c$\temp") -Credential $cred            #Kolla om skripten redan finns, om dom inte finns så kopiera över dom.
            if (-Not (test-path ("\\" + $compName + "\c$\temp\SpeculationControl.psd1")))
            {
               Copy-Item "\\srvdc01\power\Spectre\sp*" -Destination ($compName + ":")
            }                #Plocka bort uppmappnig som användes för kopiering                Get-psdrive -Name $compName | Remove-PSDrive -Force                    #Kör kollen på fjärrdatorn.                    $Global:resultat += Invoke-Command -ComputerName $compname -ScriptBlock { Import-Module c:\temp\SpeculationControl.psd1; Get-SpeculationControlSettings } -Credential $cred
    }
}