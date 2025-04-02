# Rename Server
$ComputerName = Read-Host "Enter Computer's name"
Rename-Computer -NewName $ComputerName -Force
Write-Output "Name changed to $ComputerName"

# Ask for IP configuration
$IPAddress = Read-Host "Enter the IP Address (e.g., 192.168.37.240)"
$PrefixLength = Read-Host "Enter the Subnet Prefix Length (e.g., 24)"
$DefaultGateway = Read-Host "Enter the Default Gateway (e.g., 192.168.37.254)"

# Get the network adapter's Interface Index
$Adapter = Get-NetAdapter | Select-Object -First 1
if (-not $Adapter) {
    Write-Output "No network adapter found! Exiting..."
    exit
}

$InterfaceIndex = $Adapter.ifIndex

# Change the IP Address
Write-Output "Changing IP address..."
New-NetIPAddress -IPAddress $IPAddress -PrefixLength $PrefixLength -InterfaceIndex $InterfaceIndex -DefaultGateway $DefaultGateway
Write-Output "IP Address successfully changed to $IPAddress with Gateway $DefaultGateway"

# Get the network adapter's Interface Alias (name)
$InterfaceAlias = $Adapter.Name

# Get DNS server from user input
$DnsServer = Read-Host "Enter DNS server (e.g., 8.8.8.8)"
# Set DNS server using Interface Alias
Set-DnsClientServerAddress -InterfaceAlias $InterfaceAlias -ServerAddresses @($DnsServer)
Write-Output "DNS Changed"

# Rename NetAdapter (if needed)
$AdapterName = $Adapter.Name
if ($AdapterName -ne "LAN") {
    Rename-NetAdapter -Name $AdapterName -NewName "LAN"
    Write-Output "Renaming Network Adapter to 'LAN'"
} else {
    Write-Output "Network Adapter is already named 'LAN'"
}

# Enable Remote Desktop
Write-Output "Enabling Remote Desktop..."
# Enable Remote Desktop on the system
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name fDenyTSConnections -Value 0
# Allow RDP through the Windows Firewall
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
Write-Output "Remote Desktop enabled and firewall rule applied."

# Restart to apply
$RestartConfirmation = Read-Host "Do you want to restart the computer to apply the changes? (Answer Y or N)"

# Convert input for case-insensitivity
if ($RestartConfirmation.ToUpper() -eq 'Y') {
    Write-Output "Computer will restart"
    Restart-Computer -Force
} else {
    Write-Output "Changes applied. Please restart the computer manually"
}
