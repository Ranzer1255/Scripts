Import-Module psremoteregistry
Import-Module ActiveDirectory

$computers = Get-ADComputer -SearchBase "OU=LE,OU=COMPUTERS_OU,DC=mabankisd,DC=net" -Properties Name -Filter {OperatingSystem -notlike "*server*"} 
foreach ($computer in $computers){
    echo $computer.name
    $versions += Get-RegValue -ComputerName $computer.name -key SOFTWARE\IBoss\IBSA\Parameters -Value version
}
$versions | select ComputerName, Data | sort Name