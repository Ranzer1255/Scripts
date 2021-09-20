Import-Module ActiveDirectory

class User {
    [string]$First
    [string]$Last

    User($First, $Last){
        $this.First = $First
        $this.Last = $Last
    }
}

$List = Get-Content ".\List.txt"
$aResults = get-UserObjects -Names $List | get-UserObjects
            
# ForEach($Item in $List){
#     $Item = $Item.Trim()
# 	$pieces =  $Item.Split(" ")
# 	$First = $pieces[0]
# 	$Last = $pieces[1]
#     $User = Get-ADUser -Filter{GivenName -like $First -and Surname -like $Last -and Enabled -eq $True} -Properties SamAccountName, GivenName, Surname, mail

#     $hItemDetails = New-Object -TypeName psobject -Property @{    
#         FullName = $Item
#         UserName = $User.SamAccountName
#         Email = $User.mail
#     }

#     #Add data to array
#     $aResults += $hItemDetails
    
# }

$aResults | Export-CSV ".\Results.csv" -noTypeInformation

function get-UserObjects {
    param (
        # Parameter help description
        [Parameter(Mandatory, ValueFromPipeline)]
        [String[]]
        $Names
    )

    Process {
        $rtn =  @()
        
        foreach ($n in $Names){
            $pieces = $n.Split(" ")
            $rtn += [User]::new($pieces[0],$pieces[1])
        }

        return $rtn
    }

}

function get-ADUserCollection {
    param (
        # Parameter help description
        [Parameter(Mandatory, ValueFromPipeline)]
        [User[]]
        $Users
    )

    process{
        $rtn = @()

        foreach($u in $Users){
        $rtn += Get-ADUser -Filter{GivenName -like $u.First -and Surname -like $u.Last -and Enabled -eq $True}
        }

        return $rtn
    }
}
