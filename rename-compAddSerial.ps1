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
    $cred
)

$serialNumber = (Get-WmiObject -computername $oldName -clas win32_bios|Select-Object -property serialnumber).serialnumber

$name = $newName + "-" + $serialNumber;

rename-computer -ComputerName $oldName -NewName $name -PassThru -DomainCredential $cred -Restart -Force
