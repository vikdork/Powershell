$view = New-VSCodeHtmlContentView -Title "My Custom View" -ShowInColumn One
Set-VSCodeHtmlContentView -View $view -Content "<h1>Hello world!</h1>"
Write-VSCodeHtmlContentView $view -Content "<b>I'm adding new content!</b><br />"