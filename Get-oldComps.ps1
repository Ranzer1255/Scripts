################### 
##### GLOBALS ##### 
################### 
 
# How many days ago was the lastLogon attribute updated?
param( 
$days = 60,
$path
)

 
# Import AD module 
Import-Module ActiveDirectory 

$lastLogonDate = (Get-Date).AddDays(-$days).ToFileTime() 

#Set Path to CSV


################ 
##### MAIN ##### 
################ 
 
# Query AD 
$Computers = @(Get-ADComputer -Properties Name,operatingSystem,lastLogontimeStamp -Filter {lastLogontimeStamp -le $lastLogonDate}) 
foreach($Computer in $Computers) 
{ 
    $Computer.OperatingSystem = $Computer.OperatingSystem -replace '®' -replace '™' -replace '专业版','Professional (Ch)' -replace 'Professionnel','Professional (Fr)' 
}

$Computers | 
    Select-Object Name, @{name='LastLogTime'; expression={[datetime]::fromFiletime($_.lastLogontimeStamp)}} | 
    Sort-Object LastLogTime | Export-Csv -NoTypeInformation -Path $path\Win10Versions.csv

$Computers.Count
