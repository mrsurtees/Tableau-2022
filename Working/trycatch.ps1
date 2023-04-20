try{
    $versionCheck = Get-Package -Name '*Tableau*' | Where-Object -Property ProviderName -ne 'msi' | Sort-Object -Property Name -ErrorAction continue
    #write-verbose "we know there's no package"
} 
catch {write-host "first"}

Write-Verbose "Last Line"

$b  = Get-Content -Path "C:\temp\a.txt" | Select-String "^Meta"
$b
$versionCheck = Get-Package -Name '*Tableau*' | Where-Object -Property ProviderName -ne 'msi' | Select-Object -Property "InstallSource"
$versionCheck



$installSource = Get-ItemProperty -Path "registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{0618526C-56B0-489C-A91A-7091FA343B75}" | Select-Object 'InstallSource'
$installSource.InstallSource + "tableau*"



 -Name "InstallSource"
 | Select-Object InstallSource



 | Sort-Object  -name InstallSource -ErrorAction continue

uninstall-package "Tableau Prep Builder 2022.4 (22.43.23.0313.1005)"




