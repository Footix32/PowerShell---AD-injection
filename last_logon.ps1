# Target user (SamAccountName)
$TargetUser = "admin.fb"

# Retrieve the list of all Domain Controllers in the AD domain
$DCList = Get-ADDomainController -Filter * | Sort-Object Name | Select-Object Name

# Initialize LastLogon to $null as the starting point
$TargetUserLastLogon = $null

# Ensure that the Domain Controllers are available
if ($DCList.Count -eq 0) {
    Write-Host "No Domain Controllers found!" -ForegroundColor Red
    exit
}

# Loop through each Domain Controller
foreach ($DC in $DCList) {
    $DCName = $DC.Name

    Try {
        # Retrieve the lastLogon attribute value from each Domain Controller (one DC at a time)
        $LastLogonDC = Get-ADUser -Identity $TargetUser -Properties lastLogon -Server $DCName

        # Check if user exists on the DC
        if (-not $LastLogonDC) {
            Write-Host "User $TargetUser not found on $DCName." -ForegroundColor Red
            continue
        }

        # Convert the value to DateTime format
        $LastLogon = [Datetime]::FromFileTime($LastLogonDC.lastLogon)

        # If the obtained value is more recent than the one stored in $TargetUserLastLogon,
        # update the variable: this ensures that we have the most recent lastLogon by the end of the process
        if ($LastLogon -gt $TargetUserLastLogon) {
            $TargetUserLastLogon = $LastLogon
        }
    }
    Catch {
        Write-Host "Error retrieving data from $DCName: $_" -ForegroundColor Red
    }
}

Write-Host "Last logon date for ${TargetUser}:"
Write-Host $TargetUserLastLogon
