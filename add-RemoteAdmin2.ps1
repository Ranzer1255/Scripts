[cmdletbinding()]
param(
    [parameter(mandatory=$true)]
    [String]$computersfile,
    [parameter(mandatory=$true)]
    [String]$username,
    [parameter(mandatory=$true)]
    [securestring]$password,
    [parameter(mandatory=$true)]
    [String]$fullname,
    [String]$local_security_group = "Administrators",
    [String]$description
)

$computers = Get-Content $computersfile
#$computers = Import-CSV C:\Computers.csv | select Computer
$sessions = New-PSSession -ComputerName $computers


Invoke-Command -Session $sessions {\\files\staff\jrdillingham\scripts\create-LocalAdminAccount.ps1 -username $username -password $password -description $description}