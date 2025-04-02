# Install ADDS + DNS + RSAT Tools

$FeatureList = @("RSAT-AD-Tools", "AD-Domain-Services", "DNS")

# Get OS version
$OSVersion = (Get-CimInstance Win32_OperatingSystem).Version
Write-Output "OS Version: $OSVersion"

# Check if the OS is compatible (example for Windows Server 2016+)
if ($OSVersion -lt "10.0.14393") {
    Write-Output "This script is intended for Windows Server 2016 or later."
    return
}

foreach ($Feature in $FeatureList) {

   # Get feature state
   $FeatureState = Get-WindowsFeature -Name $Feature

   if ($FeatureState.InstallState -eq "Available") {

     Write-Output "Feature $Feature will be installed now!"

     try {
        Install-WindowsFeature -Name $Feature -IncludeManagementTools -IncludeAllSubFeature
        Write-Output "$Feature : Installation is a success!"
     } catch {
        Write-Output "$Feature : Error during installation!"
     }
   } else {
      Write-Output "$Feature is already installed or not available for installation."
   }
}
