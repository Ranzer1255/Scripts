<#
.SYNOPSIS
Copies a file or file tree to a destination share on a list of computer names supplied
#>
Param (
    # a collection of computer names to be effected by this command
    [parameter(Mandatory=$true, ValueFromPipeline)]
    [string[]] $computerlist,
    # the source file to copy
    [parameter(Mandatory=$true)]
    [string] $source,
    # the full share path on the destination computerget
    [parameter(Mandatory=$true)]
    [string] $destination,
    [switch] $recurse
)

process{
    foreach($computer in $computerslist){
        if (Test-Path -Path \\$computer\$destination){
            Write-Host "copying to $computer"
            Copy-Item $source -Destination \\$computer\$destination -force -Recurse:$recurse -Verbose
        } else {
            write-host "$computer is unreacheable"
        }
    }
}
