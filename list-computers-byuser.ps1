# List-Computers-ByUser.ps1
#
[CmdletBinding()]
param (
    # Search for user
    [Parameter(Mandatory=$false,
    ValueFromPipelineByPropertyName=$true,
    HelpMessage="If you don't pass a name you will be prompted",
    Position=0)]
    [String]
    $UserName,

    # Choose method, WMI, CIM or Query
    [Parameter(Mandatory=$false,
    ValueFromPipelineByPropertyName=$true,
    HelpMessage="Default set to WMI",
    Position=1)]
    [ValidateSet('WMI','CIM','Query')]
    [String]
    $Method = "Query"
)

# Retrieve Username to search for, error checks to make sure the username
# is not blank and that it exists in Active Directory
Function Get-Username([String]$UserName) {
    if ([string]::IsNullOrEmpty($UserName)) {
        $UserName = Read-Host "Enter username you want to search for"
    }

    $UserCheck = Get-ADUser -Identity $Username
    if ($null -eq $UserCheck) {
        Write-Debug "Invalid username, please verify this is the logon id for the account"
        $UserName = Get-Username
    }

    return $UserName
}

$Script:UserName = Get-Username $UserName

Write-Host "Checking for PS Module Get-ActiveUser ..."
if (-not (Get-InstalledModule Get-ActiveUser -ErrorAction silentlycontinue)) {
    Install-Module -Name Get-ActiveUser 
}

[String]$Global:output=@()

Write-Host "Searching for username across all computers in domain. This will take a long time ..."
$adComputers =  Get-ADComputer  -Filter 'enabled -eq "true"' -SearchBase "OU=MJH, OU=COMPUTERS_OU, DC=MABANKISD, DC=NET" | Select-Object -ExpandProperty Name
Measure-Command {
    $output = $adComputers | ForEach-Object -Parallel {
        $users = Get-ActiveUser -ComputerName $_ -Method $using:Method
        ForEach($activeUser in $users) {
            if($activeUser.UserName -eq $UserName) {
                $output+=$activeUser
                Write-Output $activeUser
            }
        }
    } 
}

# Show results, all computers that user is logged in to
$output