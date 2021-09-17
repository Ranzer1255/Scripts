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
$days = 365,
$path = "C:\users\jrdillingham\desktop"
)

 
# Import AD module 
Import-Module ActiveDirectory 

$lastLogonDate = (Get-Date).AddDays(-$days).ToFileTime() 

#Set Path to CSV


################ 
##### MAIN ##### 
################ 
 
# Query AD 
$Computers = @(Get-ADComputer -Properties Name,operatingSystem,lastLogontimeStamp,operatingSystemVersion -Filter {(OperatingSystem -like "*Windows 7*")  -AND (lastLogontimeStamp -ge $lastLogonDate) -and -not(operatingSystemVersion -like '*17763*')}) 
foreach($Computer in $Computers) 
{ 
    $Computer.OperatingSystem = $Computer.OperatingSystem -replace '®' -replace '™' -replace '专业版','Professional (Ch)' -replace 'Professionnel','Professional (Fr)' 
}

$Computers | Select Name, operatingSystemVersion | Sort operatingSystemVersion,name