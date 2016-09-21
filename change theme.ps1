$Ssu_theme = "SwedishSummer.themepack"
$Ssp_theme = "SwedishSpring.themepack"
$Win_theme = "SwedishWinter.themepack"
$Aut_theme = "SwedishAutumn.themepack"

$Ssu = "http://download.microsoft.com/download/A/7/4/A7448DBD-5723-44C1-BBB1-51FB285DEB0E/" + $Ssu_theme
$Ssp = "http://download.microsoft.com/download/A/7/4/A7448DBD-5723-44C1-BBB1-51FB285DEB0E/" + $Ssp_theme
$Win = "http://download.microsoft.com/download/A/7/4/A7448DBD-5723-44C1-BBB1-51FB285DEB0E/" + $Win_theme
$Aut = "http://download.microsoft.com/download/A/7/4/A7448DBD-5723-44C1-BBB1-51FB285DEB0E/" + $Aut_theme


$reg_path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\themes"
$reg = Get-ItemProperty -Path $reg_path

$Ssu_theme_reg = "Swedish S\Swedish S.theme"
$Ssp_theme_reg = "Swedish S (2)\Swedish S.theme"
$win_theme_reg = "Swedish W\Swedish W.theme"
$Aut_theme_reg = "Swedish A\Swedish A.theme"



$summer = 152..243
$spring = 60..151
$winter1 = 335..365
$winter2 = 1..59
$winter = $winter1 + $winter2
$Autum = 244..334

$date = get-date

switch ($date.DayOfYear)
{
    {$_ -in $summer} 
    {
    if ($reg.CurrentTheme -notlike "*$Ssu_theme_reg*")
{ if (Test-Path c:\temp\$Ssu_theme)
  {   & c:\temp\$Ssu_theme
  Start-Sleep -Seconds 2
$shell = New-Object -ComObject WScript.Shell; $shell.AppActivate('Personalization'); $shell.SendKeys('%{F4}')

      
  }
  else
  {Start-BitsTransfer $Ssu -Destination c:\temp\$Ssu_theme
  & c:\temp\$Ssu_theme
  Start-Sleep -Seconds 2
$shell = New-Object -ComObject WScript.Shell; $shell.AppActivate('Personalization'); $shell.SendKeys('%{F4}')
}
  }
    }
    {$_ -in $spring} {
    if ($reg.CurrentTheme -notlike "*$Ssp_theme_reg*")
{ if (Test-Path c:\temp\$Ssp_theme)
  {   & c:\temp\$Ssp_theme
  Start-Sleep -Seconds 2
$shell = New-Object -ComObject WScript.Shell; $shell.AppActivate('Personalization'); $shell.SendKeys('%{F4}')

      
  }
  else
  {Start-BitsTransfer $Ssp -Destination c:\temp\$Ssp_theme
  & c:\temp\$Ssp_theme
  Start-Sleep -Seconds 2
$shell = New-Object -ComObject WScript.Shell; $shell.AppActivate('Personalization'); $shell.SendKeys('%{F4}')
}
  }
    }
    {$_ -in $winter} {
        if ($reg.CurrentTheme -notlike "*$win_theme_reg*")
{ if (Test-Path c:\temp\$win_theme)
  {   & c:\temp\$win_theme
  Start-Sleep -Seconds 2
$shell = New-Object -ComObject WScript.Shell; $shell.AppActivate('Personalization'); $shell.SendKeys('%{F4}')

      
  }
  else
  {Start-BitsTransfer $win -Destination c:\temp\$win_theme
  & c:\temp\$win_theme
  Start-Sleep -Seconds 2
$shell = New-Object -ComObject WScript.Shell; $shell.AppActivate('Personalization'); $shell.SendKeys('%{F4}')
}
  }
    }
    {$_ -in $Autum} {
    if ($reg.CurrentTheme -notlike "*$aut_theme_reg*")
{ if (Test-Path c:\temp\$aut_theme)
  {   & c:\temp\$aut_theme
  Start-Sleep -Seconds 2
$shell = New-Object -ComObject WScript.Shell; $shell.AppActivate('Personalization'); $shell.SendKeys('%{F4}')

      
  }
  else
  {Start-BitsTransfer $aut -Destination c:\temp\$aut_theme
  & c:\temp\$aut_theme
  Start-Sleep -Seconds 2
$shell = New-Object -ComObject WScript.Shell; $shell.AppActivate('Personalization'); $shell.SendKeys('%{F4}')
}
  }}
  }