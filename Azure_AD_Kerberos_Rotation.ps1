<#
-Ensure AD replication is complete before rotation
-Monitor logs for any authentication issues
-Schedule rotation outside business hours
-Use Azure AD Connect to sync changes
#>


$LogFile = "C:\Logs\AzureAD_Kerberos_Rotation.log"
if (!(Test-Path "C:\Logs")) { New-Item -ItemType Directory -Path "C:\Logs" | Out-Null }

try {
    Write-Output "$(Get-Date) - Rotating Azure AD Kerberos password..." | Out-File -Append $LogFile
    Reset-AzureADKerberosServer -DomainController (Get-ADDomainController).Name
    Write-Output "$(Get-Date) - Azure AD Kerberos password rotation successful." | Out-File -Append $LogFile
} catch {
    Write-Output "$(Get-Date) - ERROR: Failed to rotate Azure AD Kerberos password. $_" | Out-File -Append $LogFile
}