Clear-Host
$VerbosePreference = "Continue"
$ProgressPreference = "SilentlyContinue"
copy-item "./*.csv" "c:\temp\installersArray.csv"
#%%%%%%%%%%%%%%%%%%
#      Start       #
#      PURPOSE:  reads in a csv with headings of "path, hash, name, url".  With these
#      populated the script will install the requested software...in this case it's
#      for Chartis Tableau
#
#      Checks if latest Tableau versions are installed and, if not, installs.  Back one version is kept.
#%%%%%%%%%%%%%%%%%%
#all working....get error checking in place
function WriteTo-UDF {
    Param
    (
        [Parameter(Mandatory = $true)]  [int]$UdfNumber,
        [Parameter(Mandatory = $true)]  [string]$UdfMessage
    )

    if ($udfNumber -lt 1 -or $UdfNumber -gt 30) {
        $msg = 'Fatal Error in Script Execution\Invalid UDF Number in WriteTo-UDF function call: $($UdfNumber.ToString())'
        Write-Error -Message $msg -Category InvalidArgument -ErrorAction Stop

    }

    $udfName = 'Custom' + $UdfNumber.ToString()
    $Result = New-ItemProperty -Path "HKLM:\SOFTWARE\CentraStage" -Name $udfName -PropertyType 'String' -Value $UdfMessage

}

#remove and create temp folder
if (-not (Test-Path "c:\temp")) {
    New-Item -Path "c:\temp"
}

###Get username #####
$liu = (Get-CimInstance -ClassName Win32_ComputerSystem).UserName

###$userID needs to be error checked since issues are possible
$userID = $liu.split("\")[1]
$user = New-Object System.Security.Principal.NTAccount($liu)
$userSID = $user.Translate([System.Security.Principal.SecurityIdentifier])
$UdfContent = ""

#Ensure there is a user logged in; abort execution if not
if ($userID -like "") {
    WriteTo-UDF -udfNumber 15 -UdfMessage "No User Logged In"
    $UdfContent += "_User:NO| "
    Write-Error -Message "Error: No user logged into system. Script execution terminating." -Category ObjectNotFound -ErrorAction Stop
} else {
    $UdfContent += "_User:YES|"
}

# Find Shortcuts
    ForEach ($file in (Get-ChildItem "C:\users\$userID\appdata\" -Include "*tableau*.lnk" -Recurse) ) {

        Remove-Item $file.FullName
    }
    ForEach ($file in (Get-ChildItem "C:\users\Public\Desktop\" -Include "*tableau*.lnk" -Recurse) ) {
        Remove-Item $file.FullName
    }




$Installers = Import-Csv C:\temp\installersArray.csv
foreach ($Installer in $Installers) {

    try {
       #invoke-WebRequest -Uri $Installer.url -OutFile $Installer.path

    } catch {
        WriteTo-UDF -UdfNumber 15 -UdfMessage "Invoke-WebRequest Failed. We stop."
        Write-Error -Message "Invoke-WebRequest Failed. Installation Archive not downloaded." -Category OpenError -ErrorAction Stop
        $UdfContent += "_IVWR:Invoke ERROR| "
    }

    $Hashesverify = Get-FileHash $Installer.path
    #write-hosts for testing
    Write-Verbose "GETTING HASH"
    Write-Verbose $Hashesverify.hash

    if ($Hashesverify.hash -eq $Installer.hash) {
        Write-Verbose "Hashes match - proceeding"
    } else {
        WriteTo-UDF -udfNumber 15 -UdfMessage "Archive Hash Mismatch"
        Write-Error -Message "Hashes do not match - corrupt Installers Archive detected." -Category InvalidData -ErrorAction Stop
        $UdfContent += "_InHash:hash Mismatch"
    }

}

#Desktop 2023 Check
# Latest version is 2023.1. THere are no other 2023 versions
# Do NOT INSTALL if already NOT installed
# Execute installer to just remove previous items
$ExePath = "C:\Program Files\Tableau\Tableau 2023.1\bin\tableau.exe"
$fileExists = Test-Path $ExePath -ErrorAction continue
if ($fileExists) {
    $UdfContent += "_D23:PreExisting|"
    Write-Verbose "Current Desktop 2023.1 already installed"
    }
     else {
    Write-Verbose "Current Desktop 2023.1 is NOT Installed....Skipping"
    $UdfContent += "_D23:Skip|"
   }


#Desktop 2022.3 Check
$ExePath = "C:\Program Files\Tableau\Tableau 2022.3\bin\tableau.exe"
$fileExists = Test-Path $ExePath -ErrorAction continue
if ($fileExists) {
    $UdfContent += "_D22:PreExisting"
    Write-Verbose "Current Desktop 2022.3 version already installed"}
     else {
    Write-Verbose "Current Desktop 2022.3 is NOT Installed....installing"
    $UdfContent += "_D22:Installed|"
    $p = Start-Process "c:\temp\TableauDesktop-64bit-2022-4-2.exe" -ArgumentList "ACCEPTEULA=1 DESKTOPSHORTCUT=0 REMOVEINSTALLEDAPP=1 /repair /quiet" -PassThru
    $p.WaitForExit()
    }

#Prep 2022.4 Install
$PrepPath = "C:\Program Files\Tableau\Tableau Prep Builder 2022.4\Tableau Prep Builder.exe"
$fileExists = Test-Path $PrepPath
if ($fileExists) {
    $UdfContent += "_P22:PreExisting|"
    Write-Verbose "Current Prep 2022.4 version already installed"
} else {
    #Install Current Version
    $UdfContent += "_p22:NO|"
    Write-Verbose "Prep 2022.4 NOT Installed....installing Prep"
    Start-Process "C:\Temp\TableauPrep-2022-4-3.exe"  -ArgumentList "ACCEPTEULA=1 DESKTOPSHORTCUT=0 REMOVEINSTALLEDAPP=1 /repair /quiet"
    }


# import installersAray.csv into array
# loop through the array
# foreach: compare $installed.installedhash with get-filehash $installed.installedpath
# if $installed.installedhash -eq $get-filehash $installed.installedpath
# EQUAL:  we know exe is good.  Move one
# NOT-EQUAL  STOP.  Hashes don't match
$installed = Import-Csv -Path "C:\temp\installersArray.csv"

<#
foreach ($i in $installed) {
    if ($i.installedhash -eq $(Get-FileHash $i.installedpath).hash) {
        Write-Verbose "$($i.installedname) is OK:  hashes match"
        $UdfContent += "_InHash:YES $($i.installedName)|"
    } else {
        Write-Verbose "$($i.installedname) has an incorrect hash so we must stop."
        writeto-udf -udfNumber 15 "$($i.installedName) hash is incorrect so we must stop"
        $UdfContent += "_InHash:NO|"
        Write-Error -Message "We have bad hash" #-Category InvalidData -ErrorAction Stop
    }
}
#>



<#
if (Test-Path "C:\temp\TableauPrep-2022-4-2.exe")
    {Remove-Item "C:\temp\TableauPrep-2022-4-2.exe"
    }
if (Test-Path -path "C:\temp\TableauDesktop-64bit-2022-4-2.exe")
    {Remove-Item "C:\temp\TableauDesktop-64bit-2022-4-2.exe"}
#>
$UdfContent += "_SCRIPT:DONE"
#Write the final UdfContent to UDF 15
WriteTo-UDF -UdfNumber 15 -UdfMessage $UdfContent
write-verbose $UdfContent
