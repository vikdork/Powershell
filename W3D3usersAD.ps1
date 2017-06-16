
    $query = "SELECT TOP (1000) [c_rowid]
          ,[c_customerref]
          ,[c_personref]
          ,[c_user_ref]
          ,[c_userid]
          ,[c_name]
          ,[c_organization]
          ,[c_postaddr]
          ,[c_postaddr2]
          ,[c_postno]
          ,[c_city]
          ,[c_country]
          ,[c_phone]
          ,[c_cellular]
          ,[c_fax]
          ,[c_email]
          ,[c_description]
          ,[c_generic1]
          ,[c_generic2]
          ,[c_generic3]
          ,[c_generic4]
          ,[c_generic5]
          ,[c_cancelled]
          ,[c_change_pwd_next_login]
      FROM [W3D3].[dbo].[t_citizen_login]"

        $w3d3DbUsers = Invoke-Sqlcmd -ServerInstance "srv-w3d3db01" -Database W3D3 -Query $query | where-object {$_.c_userid.length -lt 20 -or $_.c_cancelled -like "1"}
        $Global:UsersNotInAD = @()
        $Global:UsersFoundInAD = @()
         
         foreach ($user in $w3d3DbUsers)
         {
             try
             {
                   $getAdUser = Get-ADUser $user.c_userid -ErrorAction Stop
                   $Global:UsersFoundInAD += [PSCustomObject]@{
                        "Användarnamn" = $user.c_userid
                        "Namn enligt W3D3" = $user.c_name
                        "Name enligt AD" = ($getAdUser.GivenName + " " + $getAdUser.surname)
                        "Organisation" = $user.c_organization
                    }
                Remove-Variable -Name getAdUser
             }
             catch 
             {
                    Write-Host "Användaren $($user.c_userid) finns inte i AD:t"
                    $Global:UsersNotInAD += [PSCustomObject]@{
                            "Användarnamn" = $user.c_userid
                            "Namn" = $user.c_name
                        }

             }
             
         }
