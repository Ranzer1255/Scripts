[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [String]
    $csvFile
)

$printers = import-csv $csvFile

$list = new-object -TypeName System.collections.ArrayList

foreach ($printer in $printers) {

    if($null -eq $printer.ipAddress) {continue}

    Write-Verbose "testing $($printer.name)"
    
    $results = new-object -TypeName PSObject -Property @{
        Name = $printer.Name
        ipAddress = $printer.ipAddress
        online = (Test-Connection $printer.ipAddress -count 1 -Quiet)
        lastTest=Get-Date
    }

    $null = $list.add($results)
}

$list