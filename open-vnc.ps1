<#
.synopis

.parameter computerlist

#>
Param (
    [parameter(Mandatory=$true)]
    [string] $computerlist,
	[parameter(Mandatory=$true)]
	[string] $password
)

$computers = get-content $computerlist

foreach($computer in $computers){
    start-process "C:\Program Files (x86)\TightVNC\tvnviewer.exe" -ArgumentList "$computer -password=$password"
}