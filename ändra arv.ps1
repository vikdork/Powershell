#-------------------------------------------------------------
#NAME: set folder inheritance.ps1
#AUTHOR: Viktor Lindström
#
#COMMENTS: set folder inheritance behavior
#-------------------------------------------------------------
$path = "I:\gemensam\saf\Administration och nämnd\Arkiverat från Insidan"
$acl= Get-Acl -Path $path 
$acl.AreAccessRulesProtected
$isProtected = $false
$preserveInheritance = $true
$acl.SetAccessRuleProtection($isProtected, $preserveInheritance)
Set-Acl -Path $path -AclObject $acl