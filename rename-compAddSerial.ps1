[CmdletBinding()]
param (
    #old name of the computer to be renamed
    [Parameter(Mandatory)]
    [string]
    $oldName,

    # new name of the computer to be put before the -serialnumber. insure the name is no more than 7 characters
    [Parameter(Mandatory)]
    [string]
    $newName,

    # domain credental to use when renaiming the computer
    [Parameter()]
    [System.Management.Automation.PSCredential]
    $cred,

    # Parameter help description
    [Parameter()]
    [switch]
    $Restart
)

try {
    #get serial number
    $wmi = Get-WmiObject -computername $oldName -clas win32_bios -ErrorAction Stop | Select-Object -property serialnumber
    $serialNumber = $wmi.serialnumber

    #generate new name
    $name = $newName + "-" + $serialNumber

    #write name to computer
    rename-computer -ComputerName $oldName -NewName $name -PassThru -DomainCredential $cred -Restart:$Restart -Force
}
catch {
    "error connecting to $oldName"
}