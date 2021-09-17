<#     
.SYNOPSIS     
     
  Get all computer objects from Active Directory with "Windows 10" in the OS name, sort by Build and export to CSV locaed in -path 
         
.COMPATABILITY      
      
  Tested on PS v4.  
       
.EXAMPLE   
  PS C:\> Get-Win10versions.ps1
  
.EXAMPLE
  PS C:\> Get-Win1oversions -days 30 -path <path>   
   
.NOTES     
         
  NAME:       Get-Win10versions.ps1     
     
  AUTHOR:     Bobby     
     
  CREATED:    12/06/18   
#> 

 
################### 
##### GLOBALS ##### 
################### 
 
# How many days ago was the lastLogon attribute updated?
param( 
$days = 30,
$path = "C:\users\jrdillingham\desktop"
)

 
# Import AD module 
Import-Module ActiveDirectory 

$lastLogonDate = (Get-Date).AddDays(-$days).ToFileTime() 

function ConvertTo-OperatingSystem {
    [CmdletBinding()]
    param(
        [string] $OperatingSystem,
        [string] $OperatingSystemVersion
    )
    if ($OperatingSystem -like 'Windows 10*') {
        $Systems = @{
			'10.0 (19041)' = "Windows 10 2004"
            '10.0 (18363)' = "Windows 10 1909"
            '10.0 (18362)' = "Windows 10 1903"
            '10.0 (17763)' = "Windows 10 1809"
            '10.0 (17134)' = "Windows 10 1803"
            '10.0 (16299)' = "Windows 10 1709"
            '10.0 (15063)' = "Windows 10 1703"
            '10.0 (14393)' = "Windows 10 1607"
            '10.0 (10586)' = "Windows 10 1511"
            '10.0 (10240)' = "Windows 10 1507"
            '10.0 (18898)' = 'Windows 10 Insider Preview'
        }
        $System = $Systems[$OperatingSystemVersion]
    } elseif ($OperatingSystem -notlike 'Windows 10*') {
        $System = $OperatingSystem
    }
    if ($System) {
        $System
    } else {
        "unknown: " + $OperatingSystemVersion
    }
}



################ 
##### MAIN ##### 
################ 
 
# Query AD 
$Computers = @(Get-ADComputer -Properties Name,operatingSystem,lastLogontimeStamp,operatingSystemVersion -Filter {(OperatingSystem -like "*Windows 10*")  -AND (lastLogontimeStamp -ge $lastLogonDate) }) 
foreach($Computer in $Computers) 
{ 
    $Computer.OperatingSystem = ConvertTo-OperatingSystem -OperatingSystem $Computer.OperatingSystem -OperatingSystemVersion $Computer.OperatingSystemVersion
}

#$Computers | Select Name, operatingSystem | Sort name,operatingSystem | Export-Csv -NoTypeInformation -Path $path\Win10Versions.csv
$Computers | Select Name, operatingSystem | Group-Object operatingSystem | select count, name |  sort name