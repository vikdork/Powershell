$computers = Get-ADComputer -SearchBase "OU=LapTop,OU=WS,OU=BUF,OU=Förvaltningar,OU=Data,DC=adm,DC=huddinge,DC=se" -filter 'Name -like "buf*"' 
$defaults = 'Kommandot har utf”rts.', "HUDDINGE\IT-Tekniker", "HUDDINGE\Domain Admins", 'Administrat”r'

$result = @()
$svararInte = @()

foreach ($item in $computers.name)
{
    write-host "Nu testar vi dator $item"
    if (Test-Connection $item -Count 1 -Quiet) {
        $users = invoke-command {net localgroup administratörer | Where-Object {$using:defaults -notcontains $_ -and $_} | select -skip 4} -computer $item
        foreach ($user in $users)
        {
            $result += New-Object -TypeName PSObject -Property @{
                Computer = $item
                User = $user
                }
        }
    }
   else 
   {
   $svararInte += $item
   }
 }
