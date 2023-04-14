##version checking installed
$0353Installed = "no"
$versionCheck = Get-Package -Name '*Tableau*' | Where-Object -Property ProviderName -ne 'msi' | Sort-Object -Property Name | Select-Object -Property Name 
$versionCheck.Name  | Out-File "c:\temp\versionCheck.csv"
if (Select-String -Path 'C:\temp\versionCheck.csv' -Pattern ".0353" -SimpleMatch)
    {echo "Latest version installed"
    $0353Installed = "yes"}
else
    {Start-Process "C:\temp\TableauDesktop-64bit-2022-4-2.exe" -ArgumentList "ACCEPTEULA=1 DESKTOPSHORTCUT=1 REMOVEINSTALLEDAPP=1 /quiet" -PassThru
}
$versionArray = import-csv "c:\temp\versionCheck.csv"

if ($0353Installed -eq "yes")
{
    if (Select-String -Path C:\temp\versionCheck.csv -Pattern ".2136" -SimpleMatch){echo "start-process $oldPrepRemovals.FullName -ArgumentList "/uninstall /quiet""}
else{echo "Old version 2136 not installed"}
    if (Select-String -Path C:\temp\versionCheck.csv -Pattern ".1841" -SimpleMatch){echo "start-process $oldPrepRemovals.FullName -ArgumentList "/uninstall /quiet""}
else{echo "Old version 1841 not installed"}
    if (Select-String -Path C:\temp\versionCheck.csv -Pattern ".1653" -SimpleMatch){echo "start-process $oldPrepRemovals.FullName -ArgumentList "/uninstall /quiet""}
else{echo "Old version 1653 not installed"}
}


uninstall-package