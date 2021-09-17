Import-Module ActiveDirectory

$aResults = @()
$List = Get-Content ".\List.txt"
            
ForEach($Item in $List){
    $Item = $Item.Trim()
	$pieces =  $Item.Split(" ")
	$First = $pieces[0]
	$Last = $pieces[1]
    $User = Get-ADUser -Filter{GivenName -like $First -and Surname -like $Last -and Enabled -eq $True} -Properties SamAccountName, GivenName, Surname, mail

    $hItemDetails = New-Object -TypeName psobject -Property @{    
        FullName = $Item
        UserName = $User.SamAccountName
        Email = $User.mail
    }

    #Add data to array
    $aResults += $hItemDetails
}

$aResults | Export-CSV ".\Results.csv" -noTypeInformation