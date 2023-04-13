##version checking installed
$versionCheck = Get-Package -Name '*Tableau*' | Where-Object -Property ProviderName -ne 'msu' | Sort-Object -Property Name | Select-Object -Property Name 
$versionCheck.Name  | Out-File "c:\temp\versionCheck.csv"
if (Select-String -Path C:\temp\versionCheck.csv -Pattern ".0353" -SimpleMatch){echo "Latest version installed"}
else
{our normal install script}


$0353Installed = "yes"
if ($0353Installed -eq "yes")
{
    if (Select-String -Path C:\temp\versionCheck.csv -Pattern ".2136" -SimpleMatch){echo "start-process $oldPrepRemovals.FullName -ArgumentList "/uninstall /quiet""}
else{echo "Old version 2136 not installed"}
    if (Select-String -Path C:\temp\versionCheck.csv -Pattern ".1841" -SimpleMatch){echo "start-process $oldPrepRemovals.FullName -ArgumentList "/uninstall /quiet""}
else{echo "Old version 1841 not installed"}
    if (Select-String -Path C:\temp\versionCheck.csv -Pattern ".1653" -SimpleMatch){echo "start-process $oldPrepRemovals.FullName -ArgumentList "/uninstall /quiet""}
else{echo "Old version 1653 not installed"}
}

