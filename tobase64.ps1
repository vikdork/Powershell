$Text = ‘ip1-12345:CnbXFfyTM5BTKh7uNV’
$Bytes = [System.Text.Encoding]::Unicode.GetBytes($Text)
$base64 =[Convert]::ToBase64String($Bytes)
$basicAuthValue = "Basic $base64"
$headers = @{ Authorization = $basicAuthValue }


