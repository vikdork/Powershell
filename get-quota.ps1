$basePath = "D:\Forvaltningar\"

#Import AD-modul
try
    {Import-Module ActiveDirectorys -ErrorAction Stop}
        catch 
    {$catchImportError = “Du har inte installerat RSAT se https://wiki.....”}

#Ersätts av textbox i gui
        $user=Read-Host "skriv användarnamn"

        #Get förvaltning to be able to build path
        $users=Get-ADUser $user 
        if($users.DistinguishedName -like "*OU=KSF*")
        {$förvaltning="KSF"}
         elseif ($users.DistinguishedName -like "*OU=SAF*")
        {$förvaltning="SAF"}
         elseif
        ($users.DistinguishedName -like "*OU=BUF*")
        {$förvaltning="BUF"}
         elseif
        ($users.DistinguishedName -like "*OU=KUF*")
        {$förvaltning="KUF"}
         elseif
        ($users.DistinguishedName -like "*OU=NBF*")
        {$förvaltning="MSB"}

        # Build full path
        $fullPath = $basePath + $förvaltning + "\" + $user

            # Create pssession against fileserver. Using try catch finally if users current credetials dosn´t work
            try
            {
                $ps = New-PSSession -ComputerName srv-fil02 -ErrorAction stop
            }
            catch
            {
                $errorPsSession = "Fel Credentials"
            }
            Finally 
            {
                if ($errorPsSession -eq "Fel Credentials")
                {
                $UserCredential = Get-Credential
                $ps = New-PSSession -ComputerName srv-fil02 -ErrorAction stop -Credential $UserCredential
                }
               }

        #POC connect pass variable
        #Invoke-Command -Session $ps -ScriptBlock {param ($fullPath) write-host $fullPath} -ArgumentList $fullPath
        $ResultQuota = Invoke-Command -Session $ps -ScriptBlock {param ($fullPath) Get-FsrmQuota -Path $fullPath | select path,Template,@{n='Usage';e={[int]($_.Usage/1MB)}},@{n='Size';e={[int]($_.Size/1MB)}}} -ArgumentList $fullPath 
        $ResultQuota