cls
Remove-Item "c:\temp\builds.txt" -ErrorAction Ignore
$versionCheck = "."
##version checking installed
$VerbosePreference = "Continue"
$0353Installed = "no"
try{
        #$versionCheck = Get-Package -Name '*Tapbleau*' | Where-Object -Property ProviderName -ne 'msi' | Sort-Object -Property Name -ErrorAction SilentlyContinue
        $versionCheck = Get-Package -Name '*Tableau*' | Where-Object -Property ProviderName -ne 'msi' | Select-Object version
        $versionCheck | Out-File "c:\temp\builds.txt"
} 
catch {write-host "first"}


Write-Verbose "ppp"
Write-Error -Message "Error: No user logged into system. Script execution terminating." -Category ObjectNotFound -ErrorAction Stop
}


Write-Error -Message "Removal "poopfailed" -Category InvalidOperation -ErrorAction Continue---

try {
    # code to be executed
    Get-ChildItem -Path 'C:\Windows' -Recurse -ErrorAction Stop
}
catch {
    # code to handle errors
    Write-Error "Error occurred: $($_.Exception.Message)"
}





$versionCheck
$versionCheck.installsource  | Out-File "c:\temp\tableau_builds.txt"
if (Select-String -Path 'c:\temp\tableau_builds.txt' -Pattern ".0353" -SimpleMatch)
    {echo "Latest version installed"
    $0353Installed = "yes"}
else
    {Start-Process "C:\temp\TableauDesktop-64bit-2022-4-2.exe" -ArgumentList "ACCEPTEULA=1 DESKTOPSHORTCUT=1 REMOVEINSTALLEDAPP=1 /quiet" -PassThru
}
$versionArray = import-csv "c:\temp\tableau_builds.txt"

foreach ($version in $versionCheck){
start-process $oldPrepRemovals.FullName -ArgumentList "/uninstall /quiet"
}


if ($0353Installed -eq "yes")

<#{
    if (Select-String -Path C:\temp\versionCheck.txt -Pattern ".2136" -SimpleMatch){echo "start-process $oldPrepRemovals.FullName -ArgumentList "/uninstall /quiet""}
else{echo "Old version 2136 not installed"}
    if (Select-String -Path C:\temp\versionCheck.txt -Pattern ".1841" -SimpleMatch){echo "start-process $oldPrepRemovals.FullName -ArgumentList "/uninstall /quiet""}
else{echo "Old version 1841 not installed"}
    if (Select-String -Path C:\temp\versionCheck.txt -Pattern ".1653" -SimpleMatch){echo "start-process $oldPrepRemovals.FullName -ArgumentList "/uninstall /quiet""}
else{echo "Old version 1653 not installed"}
}



Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*Jump Client*cloud" | Select-Object DisplayName, UninstallString

(Get-Package -Name "*tableau*".source)  
| Select-Object -source

$a 
$a = Get-Package -Name "*tableau*" | Select-Object -Property "uninstallstring" | fl
$a
$oldPrepRemovals = Get-ChildItem -Recurse -Path "C:\programdata\Package Cache" -Include "Tableau*.exe"
$oldPrepRemovals
foreach ($i in $oldPrepRemovals.fullname) {
start-process $i -ArgumentList "/uninstall /quiet"
}

#>
cls
$a = 
Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*tableau*"  | Select-Object -

