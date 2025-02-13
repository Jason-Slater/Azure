
#<
- Checks if the last KRBTGT password rotation was over 180 days ago
- Performs a rotation only if necessary
- Logs actions and errors for auditing
#>





# Define log file location
$LogFile = "C:\Logs\KRBTGT_Rotation.log"

# Ensure log folder exists
if (!(Test-Path "C:\Logs")) {
    New-Item -ItemType Directory -Path "C:\Logs" | Out-Null
}

# Get last password change date
$LastRotation = (Get-ADUser krbtgt -Property "PasswordLastSet").PasswordLastSet
$DaysSinceLastRotation = (Get-Date) - $LastRotation

# If password is older than 180 days, rotate
if ($DaysSinceLastRotation.Days -ge 180) {
    try {
        Write-Output "$(Get-Date) - Rotating KRBTGT password..." | Out-File -Append $LogFile
        Reset-KrbtgtPassword -Domain (Get-ADDomain).DNSRoot
        Write-Output "$(Get-Date) - KRBTGT password rotation successful." | Out-File -Append $LogFile
    } catch {
        Write-Output "$(Get-Date) - ERROR: Failed to rotate KRBTGT password. $_" | Out-File -Append $LogFile
    }
} else {
    Write-Output "$(Get-Date) - No rotation needed. Last change: $LastRotation" | Out-File -Append $LogFile
}