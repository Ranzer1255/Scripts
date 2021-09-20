Import-Module ActiveDirectory

class User {
    [string]$First
    [string]$Last

    User($First, $Last){
        $this.First = $First
        $this.Last = $Last
    }
}

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
        $rtn += Get-ADUser -Filter{GivenName -like $u.First -and Surname -like $u.Last -and Enabled -eq $True} -Properties SamAccountName, GivenName, Surname, mail
        }

        return $rtn
    }
}

$List = Get-Content ".\names.txt"
$aResults = get-UserObjects -Names $List | get-ADUserCollection


$aResults | Select-Object SamAccountName, GivenName, Surname, mail | Export-CSV ".\ResultsV2.csv" -noTypeInformation
