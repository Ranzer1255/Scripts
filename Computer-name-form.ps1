Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$TSProgressUI = New-Object -COMObject Microsoft.SMS.TSProgressUI
$TSProgressUI.CloseProgressDialog()

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Select a Computer'
$form.Size = New-Object System.Drawing.Size(230,450)
$form.StartPosition = 'CenterScreen'

$btnOK = New-Object System.Windows.Forms.Button
$btnOK.Location = New-Object System.Drawing.Point(64,358)
$btnOK.Size = New-Object System.Drawing.Size(75,23)
$btnOK.Text = 'OK'
$btnOK.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $btnOK
$form.Controls.Add($btnOK)

$lblBuilding = New-Object System.Windows.Forms.Label
$lblBuilding.Location = New-Object System.Drawing.Point(20,17)
$lblBuilding.Size = New-Object System.Drawing.Size(100,18)
$lblBuilding.Text = 'Building:'
$form.Controls.Add($lblBuilding)

$lbxBuilding = New-Object System.Windows.Forms.ListBox
$lbxBuilding.Location = New-Object System.Drawing.Point(20,40)
$lbxBuilding.Size = New-Object System.Drawing.Size(175,82)
$lbxBuilding.Height = 82

[void] $lbxBuilding.Items.Add('High School')
[void] $lbxBuilding.Items.Add('Junior High')
[void] $lbxBuilding.Items.Add('Intermediate')
[void] $lbxBuilding.Items.Add('Central')
[void] $lbxBuilding.Items.Add('Southside')
[void] $lbxBuilding.Items.Add('Lakeview')
[void] $lbxBuilding.Items.Add('DAEP')
[void] $lbxBuilding.Items.Add('Academy')
[void] $lbxBuilding.Items.Add('Ag')
[void] $lbxBuilding.Items.Add('Auto')
[void] $lbxBuilding.Items.Add('Admin')
[void] $lbxBuilding.Items.Add('Maintenance')
[void] $lbxBuilding.Items.Add('Transportation')

$form.Controls.Add($lbxBuilding)

$lblRoom = New-Object System.Windows.Forms.Label
$lblRoom.Location = New-Object System.Drawing.Point(20,128)
$lblRoom.Size = New-Object System.Drawing.Size(175,32)
$lblRoom.Text = "Room: `n(3 characters, 2 for Acad and AG)"
$form.Controls.Add($lblRoom)

$txbRoom = New-Object System.Windows.Forms.TextBox
$txbRoom.Location = New-Object System.Drawing.Point(20,160)
$txbRoom.Size = New-Object System.Drawing.Size(175,20)
$txbRoom.MaxLength = 3
$form.controls.Add($txbRoom)

$lblDesignation = New-Object System.Windows.Forms.Label
$lblDesignation.Location = New-Object System.Drawing.Point(20,187)
$lblDesignation.Size = New-Object System.Drawing.Size(100,18)
$lblDesignation.Text = 'Designation:'
$form.Controls.Add($lblDesignation)

$gbxMode = New-Object System.Windows.Forms.GroupBox
$gbxMode.Location = New-Object System.Drawing.Point(20,205)
$gbxMode.Size = New-Object System.Drawing.Size(175,60)

$rdbTeacher = New-Object System.Windows.Forms.RadioButton
$rdbTeacher.Location = New-Object System.Drawing.Point(10,10)
$rdbTeacher.Size = New-Object System.Drawing.Size(104,15)
$rdbTeacher.Text = "Teacher"
$gbxMode.Controls.Add($rdbTeacher)

$rdbStudent = New-Object System.Windows.Forms.RadioButton
$rdbStudent.Location = New-Object System.Drawing.Point(10,25)
$rdbStudent.Size = New-Object System.Drawing.Size(104,15)
$rdbStudent.Text = "Student"
$gbxMode.Controls.Add($rdbStudent)

$rdbOther = New-Object System.Windows.Forms.RadioButton
$rdbOther.Location = New-Object System.Drawing.Point(10,40)
$rdbOther.Size = New-Object System.Drawing.Size(104,15)
$rdbOther.Text = "Other"
$gbxMode.Controls.Add($rdbOther)

$form.Controls.Add($gbxMode)

$lblNumber = New-Object System.Windows.Forms.Label
$lblNumber.Location = New-Object System.Drawing.Point(20,270)
$lblNumber.Size = New-Object System.Drawing.Size(175,45)
$lblNumber.Text = "2 digit number or if Other`n3 character Designation`nIE: 01 | OFF, PRN, SEC"
$form.Controls.Add($lblNumber)

$txbNumber = New-Object System.Windows.Forms.TextBox
$txbNumber.Location = New-Object System.Drawing.Point(20,314)
$txbNumber.Size = New-Object System.Drawing.Size(175,20)
$txbNumber.MaxLength = 3
$form.controls.Add($txbNumber)

#$form.Topmost = $true

[void] $form.ShowDialog()

switch ($lbxBuilding.SelectedItem) {
    "High School"       {$buildingChar = 'H' }
    "Junior High"       {$buildingChar = 'J' }
    "Intermediate"      {$buildingChar = 'I' }
    "Central"           {$buildingChar = 'C' }
    "Southside"         {$buildingChar = 'S' }
    "Lakeview"          {$buildingChar = 'L' }
    "DAEP"              {$buildingChar = 'D' }
    "Academy"           {$buildingChar = 'A' }
    "Ag"                {$buildingChar = 'AG' }
    "Auto"              {$buildingChar = 'AU' }
    "Admin"             {$buildingChar = 'X' }
    "Maintenance"       {$buildingChar = 'M' }
    "Transportation"    {$buildingChar = 'T' }
    Default             {$buildingChar = "homeles"}
}

Switch (($gbxMode.Controls | Where-Object -FilterScript {$_.Checked}).text){
    "Teacher" {$classChar = 'T'}
    "Student" {$classChar = 'S'}
    Default   {$classChar =  ''}
}
$serialNumber = (Get-WmiObject -Class "win32_BIOS").serialNumber

$tsenv = New-Object -COMObject Microsoft.SMS.TSEnvironment

$tsenv.Value("OSDComputerName") = $buildingChar + $txbRoom.Text.ToUpper() + $classChar + $txbNumber.Text.ToUpper() + "-" + $serialNumber
