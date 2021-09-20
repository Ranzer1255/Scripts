[cmdletbinding()]
param(
    [parameter(mandatory=$true)]
    [String]$computersfile,
    [parameter(mandatory=$true)]
    [String]$username,
    [parameter(mandatory=$true)]
    [SecureString]$password,
    [parameter(mandatory=$true)]
    [String]$fullname,
    [String]$local_security_group = "Administrators",
    [String]$description
)

$computers = Get-Content $computersfile
#$computers = Import-CSV C:\Computers.csv | select Computer
 
Foreach ($computer in $computers) {
    Write-Verbose "starting $computer"
    $users = $null
    $comp = [ADSI]"WinNT://$computer"
 
    #Check if username exists   
    Try {
        $users = $comp.psbase.children | Select-Object -expand name
        if ($users -like $username) {
            Write-Host "$username already exists on $computer"
 
        } else {
            #Create the account
            write-verbose "creating $username"      
            $user = $comp.Create("User","$username")
            write-verbose "setting password"
            $user.SetPassword("$password")
            write-verbose "setting description"
            $user.Put("Description","$description")
            write-verbose "setting fullname"
            $user.Put("Fullname","$fullname")
            write-verbose "calling setInfo()"
            $user.SetInfo()   
            write-verbose "done calling setInfo()"
              
            #Set password to never expire
            #And set user cannot change password
            $ADS_UF_DONT_EXPIRE_PASSWD = 0x10000 
            $ADS_UF_PASSWD_CANT_CHANGE = 0x40
            write-verbose "setting flags"
            $user.userflags = $ADS_UF_DONT_EXPIRE_PASSWD + $ADS_UF_PASSWD_CANT_CHANGE
            $user.SetInfo()
            write-verbose "done setting flags"
 
            #Add the account to the local admins group
            write-verbose "adding $username to $local_security_group"
            $group = [ADSI]"WinNT://$computer/$local_security_group,group"
            $group.add("WinNT://$computer/$username")
            write-verbose "done adding to group"
 
                #Validate whether user account has been created or not
                $users = $comp.psbase.children | Select-Object -expand name
                if ($users -like $username) {
                    Write-Host "$username has been created on $computer"
                } else {
                    Write-Host "$username has not been created on $computer"
                }
               }
        }
 
     Catch {
           Write-Host "Error creating $username on $($computer.path):  $($Error[0].Exception.Message)"
           }
}