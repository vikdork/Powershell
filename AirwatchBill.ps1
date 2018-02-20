# User testmdmlic pass qwerty12
# 


# AD-grupper
$bgtest1 = "BG test1"
$bgtest2 = "BG test2"
$bgtest5 = "BG test5"
$adGroups = $bgtest1, $bgtest2, $bgtest5



# Resultatvariabler
$adResult = @()

# Hämta användare från grupp.
     foreach ($group in $adGroups)
     {
         $adUsers= Get-ADGroupMember -Identity $group | select SamAccountName
            foreach ($aduser in $adUsers)
            {
                
                $adResult += [pscustomobject]@{
                    "User" = $adUser.SamAccountName
                    "group" = $group                    
                                            }
            }
     }
    

    # Räkna om någon finns i fler grupper 
    $hej = $adResult.user | Group-Object
    $hej | Where-Object count -gt 1 | select name

        # Hämta användare från SQL
        $getAllTablesQuery = "SELECT [ID],[SamAccountName],[Grupp] ,[Status] FROM [Airwatch].[dbo].[Faktura]"
        $getAllSqlUsers = Invoke-Sqlcmd -Server test-viktor01 -Database Airwatch -Username airwatch -Password qwerty -Query $getAllTablesQuery
            
            
            # Jämför $adResult med databasen
                foreach ($adUser in $adResult)
                {
                    # Kolla om användare finns i databasen, om den inte finns skapa användaren.
                    if (-NOT $getAllSqlUsers.samAccountName -contains $aduser.User)
                    {
                       #Skapa ny användare
                       $sqlInsertTableQuery = "INSERT INTO [Airwatch].[dbo].[Faktura] (SamAccountName, Grupp, Status) VALUES ('$($aduser.User)','$($aduser.group)', '1')"
                       $insertNewUser = Invoke-Sqlcmd -Server test-viktor01 -Database Airwatch -Username airwatch -Password qwerty -Query $sqlInsertTableQuery
                    }
                        else
                        {"Finns"}
                
                
                }
                 

        
        

        # Editera användare
        $date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $sqlUpdateTable = "UPDATE [Airwatch].[dbo].[Faktura] SET [BG test5] = '$($date)' WHERE ID = 6" 
        $insertNewUser = Invoke-Sqlcmd -Server test-viktor01 -Database Airwatch -Username airwatch -Password qwerty -Query $sqlUpdateTable




        foreach ($adUser in $adResult)
                
                    {
                        #Hämta användadare från array 
                        # HEj Viktor här ska du in med en check om användarnamn och grupp stämmer överens, samla in dem som inte gör det.
                        $SQLusername = $getAllSqlUsers | Where-Object samaccountname -EQ $aduser.SamAccountName
                        if (
                    }



        