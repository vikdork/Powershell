function build-wiki 
    {
    [CmdletBinding()]
        Param(
        [Parameter(Mandatory=$True,Position=1)]
        [string]$Server)
            #Importera servrar och tjänster samt wikipediabas för att bygga tables i wiki
            $wikiBas = Get-Content C:\temp\Wiki_bas.txt
            $import = Import-Csv C:\temp\tjänter.txt -Delimiter ";" -Encoding UTF8 | Where-Object {$_.Servername -eq $server}
            $filePath = "c:\temp\" 
            $fileName = $server +"_wiki.txt"
            New-Item -ItemType File -Path $filePath -Name $fileName 
            Add-Content -Value ($wikiBas) -Path $filePath$fileName
   
foreach ($fält in $import)
{
Add-Content -Value (
"| "+$fält.Name + "||" + $fält.Displayname + "||" +$fält.Funktion +"||"+$fält.Beroenden +"||" +$fält.'Startup Type' + "||" +$fält.'Log On As'+
"`r`n|-") -Path $filePath$fileName
    }
    
(Get-Content $filePath$fileName | Select-Object -SkipLast 1) | Set-Content $filePath$fileName
Add-Content -Value ("|}") -Path $filePath$fileName
    }
