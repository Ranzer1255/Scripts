<#     
.SYNOPSIS
Custom PRTG Sensor script to monitor and log the free IP addresses in your DHCP Scopes

.description
This script will poll your DHCP server and return a formatted JSON string to the PRTG probe for each DHCP scope on your server. To mitigate false alarms, it will check to make sure it's gotten a result for the number of scopes specified in the ExpectedScopes parameter before sending the info on to PRTG. if not it will retry a number of times specified in the parameters (default 5 tries) before sending a formatted error JSON to PRTG. 

The script will setup the channels on the sensor to go into warning state at 100 free address and Error State at 50 free address

.LINK
Powershell based Custom Sensor Guide 
https://kb.paessler.com/en/topic/71356-guide-for-powershell-based-custom-sensors

.LINK
Clear Example of Parameters for Powershell based custom sensors
https://kb.paessler.com/en/topic/63205-what-is-my-powershell-parameters

.EXAMPLE
getScopeUsage.ps1 -ComputerName DHCP-Server -ExpectedScopes 7

.EXAMPLE
getScopeUsage.ps1 -ComputerName DHCP-Server -ExpectedScopes 7 -Retries 2

.NOTES  
  NAME:       getScopeUsage.ps1     
     
  AUTHOR:     Bobby     
     
  CREATED:    11/29/2020
#> 
param (
    # Name of DHCP server to poll
    [String]
    [Parameter(Mandatory=$true)]
    $ComputerName,
    # Number of times to Retry before failing
    [int]
    $Retries=5,
    # Number of expceted scopes returned by DHCP. This should match the number of Scopes on your DHCP server. This is to mitigate false alarms in PRTG as occasionaly the Get-DhcpServerv4Scope does not return all the scopes on the server.
    [int]
    [Parameter(Mandatory=$true)]
    $ExpectedScopes
)


try{
    $ErrorActionPreference = 'Stop'
    $i = 0
    Do {
        if($i++ -eq $retries){
            throw "not all scopes were detected in the allotted retries"
        }
        $data = Get-DhcpServerv4Scope -ComputerName $ComputerName `
        | Get-DhcpServerv4ScopeStatistics -ComputerName $ComputerName `
        | Select-Object ScopeID,free

    } while ($data.Length -ne $ExpectedScopes)

    $results = $data | ForEach-Object {
        @{
            "Channel"= "Scope: " + $_.ScopeID.IPAddressToString;
            "Value"=$_.free
            "CustomUnit"="Free Ips"
            "LimitMinWarning" = 100
            "LimitMinError" = 50
            "LimitMode" = 1
        }
    } | ConvertTo-Json

    $output = @"
{
    "prtg": {
        "result": $results
    }
}
"@

    $output
} catch {
@"
    {
        "prtg": {
            "error": 1,
            "text": "$error[0]"
        }
    }
"@
}