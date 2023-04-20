Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*Jump Client*cloud" | Select-Object DisplayName, UninstallString

Get-Package -Name "*tableau*"   | Select-Object  -InstallSource

Get-Package -Name "*tableau*" | Select-Object -Property name
$oldPrepRemovals = Get-ChildItem -Recurse -Path "C:\programdata\Package Cache" -Include "Tableau*.exe"
$oldPrepRemovals
foreach ($i in $oldPrepRemovals.fullname) {
start-process $i -ArgumentList "/uninstall /quiet"
}


