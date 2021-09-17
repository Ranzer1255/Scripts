Param (
    [parameter(Mandatory=$true)]
    [string] $computerlist,
    [parameter(Mandatory=$true)]
    [string] $source,
    [parameter(Mandatory=$true)]
    [string] $destination,
    [bool] $recuse
)

Write-Host $recuse
$computers = get-content $computerlist

foreach($computer in $computers){
    if (Test-Path -Path \\$computer\$destination){
        Write-Host "copying to $computer"
        Copy-Item $source -Destination \\$computer\$destination -Force
    } else {
        write-host "$computer is unreacheable"
    }
}