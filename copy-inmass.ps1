<#
.synopis
Copies a file or file tree to a source destination on a list of computer names supplied

.parameter computerlist
a text file with a list of all computers to be effected by this command
#>
Param (
    [parameter(Mandatory=$true)]
    [string] $computerlist,
    [parameter(Mandatory=$true)]
    [string] $source,
    [parameter(Mandatory=$true)]
    [string] $destination,
    [bool] $recuse
)

$computers = get-content $computerlist
if($recuse){
    foreach($computer in $computers){
        if (Test-Path -Path \\$computer\$destination){
            Write-Host "copying to $computer"
            Copy-Item $source -Destination \\$computer\$destination -force -Recurse -Verbose
        } else {
            write-host "$computer is unreacheable"
        }
    }
} else {
    foreach($computer in $computers){
        if (Test-Path -Path \\$computer\$destination){
            Write-Host "copying to $computer"
            Copy-Item $source -Destination \\$computer\$destination -Force
        } else {
            write-host "$computer is unreacheable"
        }
    }
}