<#
PromptFor-ComputerNumber v1
-----------------
This script prompts for input during a task sequence, and sets the input as a TS variable.
#>
 
# Close the TS UI temporarily
$TSProgressUI = New-Object -COMObject Microsoft.SMS.TSProgressUI
$TSProgressUI.CloseProgressDialog()
 
# Prompt for input
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null
$ComputerNumber = [Microsoft.VisualBasic.Interaction]::InputBox("Enter the two digit number of this Computer", "Computer Number", "ie: 01")
 
# Set the TS variable
$tsenv = New-Object -COMObject Microsoft.SMS.TSEnvironment
$tsenv.Value("TSComputerNumber") = $ComputerNumber