# Scoop Installation and Java Management Script
# This script installs Scoop package manager and sets up Java development environment

# Set proxy environment variables
$env:http_proxy = "http://192.168.3.30:10809"
$env:https_proxy = "http://192.168.3.30:10809"

Write-Host "Setting up proxy configuration..." -ForegroundColor Green
Write-Host "HTTP Proxy: $env:http_proxy" -ForegroundColor Yellow
Write-Host "HTTPS Proxy: $env:https_proxy" -ForegroundColor Yellow

# Set execution policy for PowerShell scripts
Write-Host "Setting PowerShell execution policy..." -ForegroundColor Green
try {
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Write-Host "Execution policy set successfully" -ForegroundColor Green
} catch {
    Write-Host "Failed to set execution policy: $_" -ForegroundColor Red
    exit 1
}

# Download Scoop installation script
Write-Host "Downloading Scoop installation script..." -ForegroundColor Green
try {
    Invoke-RestMethod get.scoop.sh -OutFile 'install.ps1'
    Write-Host "Scoop installer downloaded successfully" -ForegroundColor Green
} catch {
    Write-Host "Failed to download Scoop installer: $_" -ForegroundColor Red
    exit 1
}

# Install Scoop to custom directory
Write-Host "Installing Scoop to custom directory..." -ForegroundColor Green
try {
    .\install.ps1 -ScoopDir 'D:\Applications\Scoop' -ScoopGlobalDir 'D:\GlobalScoopApps' -Proxy 'http://192.168.3.30:10809'
    Write-Host "Scoop installed successfully" -ForegroundColor Green
} catch {
    Write-Host "Failed to install Scoop: $_" -ForegroundColor Red
    exit 1
}

# Verify Scoop installation
Write-Host "Verifying Scoop installation..." -ForegroundColor Green
try {
    scoop
    Write-Host "Scoop verification successful" -ForegroundColor Green
} catch {
    Write-Host "Scoop verification failed: $_" -ForegroundColor Red
    exit 1
}

# Add Java bucket
Write-Host "Adding Java bucket..." -ForegroundColor Green
try {
    scoop bucket add java
    Write-Host "Java bucket added successfully" -ForegroundColor Green
} catch {
    Write-Host "Failed to add Java bucket: $_" -ForegroundColor Red
}

# Search for OpenJDK packages
Write-Host "Searching for OpenJDK packages..." -ForegroundColor Green
try {
    scoop search openjdk
} catch {
    Write-Host "Failed to search for OpenJDK: $_" -ForegroundColor Red
}

# Install JDK 8
Write-Host "Installing OpenJDK 8..." -ForegroundColor Green
try {
    scoop install openjdk8-redhat
    Write-Host "OpenJDK 8 installed successfully" -ForegroundColor Green
} catch {
    Write-Host "Failed to install OpenJDK 8: $_" -ForegroundColor Red
}

# Install JDK 11 (Note: Script mentioned JDK17 but command shows openjdk11)
Write-Host "Installing OpenJDK 11..." -ForegroundColor Green
try {
    scoop install openjdk11
    Write-Host "OpenJDK 11 installed successfully" -ForegroundColor Green
} catch {
    Write-Host "Failed to install OpenJDK 11: $_" -ForegroundColor Red
}

# Check Java version
Write-Host "Checking current Java version..." -ForegroundColor Green
try {
    java --version
} catch {
    Write-Host "Failed to check Java version: $_" -ForegroundColor Red
}

Write-Host "`n=== Java Version Management Commands ===" -ForegroundColor Cyan
Write-Host "To switch from Java 11 to Java 8:" -ForegroundColor Yellow
Write-Host "scoop reset openjdk8-redhat" -ForegroundColor White
Write-Host "`nTo switch from Java 8 to Java 11:" -ForegroundColor Yellow
Write-Host "scoop reset openjdk11" -ForegroundColor White

Write-Host "`n=== Installation Complete ===" -ForegroundColor Green
Write-Host "Scoop and Java development environment setup completed!" -ForegroundColor Green
Write-Host "You can now use the above commands to switch between Java versions as needed." -ForegroundColor Yellow

# Clean up installation file
Remove-Item -Path 'install.ps1' -Force -ErrorAction SilentlyContinue
Write-Host "Cleaned up installation files" -ForegroundColor Green