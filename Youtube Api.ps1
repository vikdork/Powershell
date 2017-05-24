$clientId = "1084032008149-h6b6vbl003cstr02losi1n4sfuf3aqtk.apps.googleusercontent.com"
$clientSecret = "Y1lABpmeYLR2Aom38FKf4oln"
$redirectUrl = "http://localhost/oauth2callback"


$apiKey = "AIzaSyDYhcXL28EounlGi5xGSuY2c1tcqi-9Ecc"
$videoId = "a_te1LiIokU"

$videuUrl = "https://www.googleapis.com/youtube/v3/captions?videoId=a_te1LiIokU&part=snippet&key=AIzaSyDYhcXL28EounlGi5xGSuY2c1tcqi-9Ecc"
$captionUrl = "https://www.googleapis.com/youtube/v3/captions/UzxW2INgOwnYJHHH8NxaJuugF2hGPSbl"

$scope = "https://www.googleapis.com/auth/youtubepartner"

$urlGetAccessToken = "https://accounts.google.com/o/oauth2/auth?redirect_uri=http%3A%2F%2Flocalhost%2Foauth2callback&scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fyoutubepartner&approval_prompt=force&access_type=offline&response_type=code&client_id=1084032008149-h6b6vbl003cstr02losi1n4sfuf3aqtk.apps.googleusercontent.com&pageId=none"


$authorationCode = "4/HZ3uKOrq8nLroW2ACzN9tXDoSWksmE9xXZ_SBhegDag"


######################################################################
$requestUri = "https://www.googleapis.com/oauth2/v4/token"
 
$body = @{
	code=$authorationCode;
	client_id=$clientId;
	client_secret=$clientSecret;
	redirect_uri=$redirectUrl;
	grant_type='authorization_code'; # Fixed value
};
 
$tokens = Invoke-RestMethod -Uri $requestUri -Method POST -Body $body -Verbose 
 
# Store refreshToken
Set-Content $PSScriptRoot"\refreshToken.txt" $tokens.refresh_token
 
# Store accessToken
Set-Content $PSScriptRoot"\accessToken.txt" $tokens.access_token


