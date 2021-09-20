<#     
.SYNOPSIS     
     
  Get all computer objects from Active Directory with "Windows" in the OS name, sort by version and outputs final result to CSV 
         
.COMPATABILITY      
      
  Tested on PS v4.  
       
.EXAMPLE   
  PS C:\> Get-OSCount.ps1   
  All options are set as variables in the GLOBALS section so you simply run the script.   
   
.NOTES     
         
  NAME:       Get-OSCount.ps1     
     
  AUTHOR:     Brian D. Arnold 
  
  MODIFIED:   Bobby Dillingham   
     
  CREATED:    8/28/14   
     
  LASTEDIT:   11/8/18    
#> 
 
################### 
##### GLOBALS ##### 
################### 
Param ( 
# How many days ago was the lastLogon attribute updated?
[parameter(Mandatory=$false)] 
$days=30,

#Set Path to CSV
[parameter(Mandatory=$false)]
$Path
)
$lastLogonDate = (Get-Date).AddDays(-$days).ToFileTime() 


# Import AD module 
Import-Module ActiveDirectory 
################ 
##### MAIN ##### 
################ 
 
# Query AD 
$Computers = @(Get-ADComputer -Properties Name,operatingSystem,lastLogontimeStamp -Filter {(OperatingSystem -like "*Windows*") -AND (lastLogontimeStamp -ge $lastLogonDate)}) 
foreach($Computer in $Computers) 
{ 
    $Computer.OperatingSystem = $Computer.OperatingSystem -replace '®' -replace '™' -replace '专业版','Professional (Ch)' -replace 'Professionnel','Professional (Fr)' 
}

$Computers | Group-Object operatingSystem | Select-Object Count,Name | Sort-Object Name | Tee-Object -Variable counts

if($Path){
    $counts | Export-Csv -Path $Path\OScount.csv -NoTypeInformation
}