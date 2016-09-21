##################################################
#Name: Convert_infile.ps1
#Aurthor: Viktor Lindström 
#
#
#
#Comments: Converts Heromfile with personal identity number to Navet compatible Infil file.
##################################################


#Variables
$personer = Get-Content "C:\PKI\personnummer.txt" | Sort-Object
$file2sökväg = "C:\pki\file2.txt"
$file4sökväg = "C:\pki\file4.txt"
$alldatafile = "C:\pki\datafil.txt"
#Count persons and add up with zeros
$antal_personer = "{0:D8}" -f $personer.Count


#Delete file2.txt if it exists.
if (test-path $file2sökväg)
{Remove-Item -Path $file2sökväg
    
}

#Delete file4.txt if it exists.
if (test-path $file4sökväg)
{Remove-Item -Path $file4sökväg
    
}

#Delete alldata.txt if it exists.
if (test-path $alldatafile)
{Remove-Item -Path $alldatafile
    
}

#Create Navet-compatible personal number 
foreach ($person in $personer)
{$person.Replace($person, "#PNR $person") | add-Content $file2sökväg 
    }


#Create Navet-compatible ANTAL_POSTER
Add-Content -Path $file4sökväg -Value "#ANTAL_POSTER $antal_personer"

#Import textfiles.
$file1 = Get-Content C:\PKI\file1.txt
$file2 = Get-Content C:\PKI\file2.txt
$file3 = Get-Content C:\PKI\file3.txt
$file4 = Get-Content C:\PKI\file4.txt
$file5 = Get-Content C:\PKI\file5.txt

#Add all data in one variable
$alldata = $file1+$file2+$file3+$file4+$file5

#Create NAvet infile
Add-Content -Path $alldatafile -Value $alldata












