<#
.SYNOPSIS
 rename all computers with a campus-room-station name scheme to the new X000T01-SERIALN scheme

.NOTES
  Name: rename_scrip

  Author: Bobby Dillingham

  Version: 1

  Created: 9-1-21
#>
param (
[parameter(Mandatory=$true)]
[string]$csvFile,

[parameter(Mandatory=$false)]
[string]$userName = "jrdillingham@mabankisd.net",

[parameter(Mandatory=$true)]
[string]$room,

[parameter(Mandatory=$true)]
[string]$campus
)

$creds = get-credential $userName

$computers = import-csv -path $csvFile

foreach($computer in $computers) {

    $oldName = $computer.name
    
    <#$Error.Clear()

	#$serialNumber = (Get-WmiObject -computername $oldName -clas win32_bios|Select-Object -property serialnumber).serialnumber

   if($Error[0].FullyQualifiedErrorId -eq "GetWMICOMException,Microsoft.PowerShell.Commands.GetWmiObjectCommand") {
        Write-Output "$oldName did not respond to WMI query"
        continue
    }#>

    $serialNumber = $oldName.Substring(8,7)

	$newName = $campus+$room+"Sxx"+"-"+$serialNumber
   Write-Output "renaming $oldName to $newName"

	rename-computer -NewName $newName -ComputerName $oldName -DomainCredential $creds -force -PassThru

}