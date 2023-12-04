# Basic Azure Configuration for connecting to Azure via Powersell
## NOTE ##
# Must run PS ISE as Adminitstrator!!

# Display Execution Policy

#Powershell Version Function
function PSVersion {
    try {
        $currentVersion = $PSVersionTable.PSVersion
        Write-Host "Current PowerShell version: " -nonewline;  Write-Host "$($currentVersion.Major).$($currentVersion.Minor).$($currentVersion.Build)" -f green
    
        $requiredVersion = [version]'5.1'  # Specify the minimum required version
    
        if ($currentVersion -lt $requiredVersion) {
            Write-Output "Upgrading PowerShell to version $requiredVersion"
            
            # Download and install PowerShell
            $url = "https://github.com/PowerShell/PowerShell/releases/download/v$($requiredVersion.Major).$($requiredVersion.Minor).$($requiredVersion.Build)/PowerShell-$($requiredVersion.Major).$($requiredVersion.Minor).$($requiredVersion.Build)-win-x64.msi"
            $installPath = "$env:TEMP\PowerShell.msi"
            
            Invoke-WebRequest -Uri $url -OutFile $installPath -UseBasicParsing
            Start-Process -Wait -FilePath msiexec -ArgumentList "/i $installPath /quiet"
            
            Write-Output "PowerShell upgraded successfully to version $requiredVersion" 
        } else {
            Write-Host "PowerShell version is: " -nonewline; Write-Host "Up to date...YEA!)" -f Green
        }
    } catch {
        Write-Error "An error occurred: $_"
    }
}

#Azure Commandlet Function
function CheckAzModule {

    try {
        # Check if the Azure PowerShell module is installed
        $azureModule = Get-Module -Name Az* -ListAvailable -ErrorAction Stop
    
        Write-Output "Azure PowerShell module found. Version: $($azureModule)"
    } catch {
        Write-Output "Azure PowerShell module not found. Installing..."
    
        # Install the Azure PowerShell module
        Install-Module -Name Az -Force -Scope CurrentUser -ErrorAction Stop
    
        Write-Output "Azure PowerShell module installed successfully."
    }
    
    }

PSVersion

CheckAzModule

