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

# Parameter help description
[Parameter()]
[Switch]
$Restart
)

$creds = get-credential $userName

$computers = import-csv -path $csvFile

foreach($computer in $computers) {

    $oldName = $computer.name

    try{
        $serialNumber = (Get-WmiObject -computername $oldName -clas win32_bios -ErrorAction stop|Select-Object -property serialnumber).serialnumber
    }
    catch{
            Write-Output "$oldName did not respond to WMI query"
            continue
    }

     
	$newName = $oldName.Substring(0,1)+$oldName.Substring(3,3)+$oldName.Substring(7,3)+"-"+$serialNumber
    Write-Output "renaming $oldName to $newName"

	rename-computer -NewName $newName -ComputerName $oldName -DomainCredential $creds -force -Restart:$Restart -PassThru

}