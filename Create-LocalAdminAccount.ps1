<#
.synopsis
creates an Administrator level account on the computer
.description
this script will Create a local Administrator account on the computer it is run.
.parameter username
Username for the account
.parameter password
password in plain text for account
#>
param(
    [parameter(Mandatory=$true)]
    [String]$username,
    [securestring]$password,
    [String]$description

)

# Check for elevation
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Warning "Oops, you need to run this script from an elevated PowerShell prompt!`nPlease start the PowerShell prompt as an Administrator and re-run the script."
	Write-Warning "Aborting script..."
    Break
}

if(!$password){
    $securepassword = Read-Host -AsSecureString -Prompt Password
} else {
    write-verbose "converting $password to a securestring object"
    $securepassword = ConvertTo-SecureString -String $password -AsPlainText -Force
}

write-verbose "creating account: $username"
New-LocalUser -Name $username -Password $securepassword -AccountNeverExpires -Description $description -PasswordNeverExpires -UserMayNotChangePassword
write-verbose "adding $username to the group administrators"
Add-LocalGroupMember -Group administrators -Member $username