# Bruno AI Assistant Prompts Installer (PowerShell)
# This script installs AI assistant prompt files for Bruno API Client projects

param(
    [string]$Mode = "interactive",
    [switch]$All,
    [switch]$Cursor,
    [switch]$Copilot,
    [switch]$VSCode,
    [switch]$General,
    [switch]$Continue,
    [switch]$Codeium
)

# Configuration
$RepoUrl = "https://raw.githubusercontent.com/bruno-collections/bruno-ai-assistant-prompts/main"

# Colors for output
function Write-Info($message) {
    Write-Host "ℹ️  $message" -ForegroundColor Blue
}

function Write-Success($message) {
    Write-Host "✅ $message" -ForegroundColor Green
}

function Write-Warning($message) {
    Write-Host "⚠️  $message" -ForegroundColor Yellow
}

function Write-Error($message) {
    Write-Host "❌ $message" -ForegroundColor Red
}

# Check if we're in a Bruno project
function Test-BrunoProject {
    if (-not (Test-Path "bruno.json")) {
        Write-Error "bruno.json not found. Please run this script from a Bruno project directory."
        exit 1
    }
    Write-Success "Bruno project detected"
}

# Create necessary directories
function New-Directories {
    Write-Info "Creating directories..."
    if (-not (Test-Path ".github")) { New-Item -ItemType Directory -Path ".github" -Force | Out-Null }
    if (-not (Test-Path ".vscode")) { New-Item -ItemType Directory -Path ".vscode" -Force | Out-Null }
    Write-Success "Directories created"
}

# Download file function
function Get-PromptFile($url, $destination) {
    try {
        Invoke-WebRequest -Uri $url -OutFile $destination -UseBasicParsing
        return $true
    }
    catch {
        Write-Error "Failed to download $url"
        return $false
    }
}

# Install functions
function Install-Cursor {
    Write-Info "Installing Cursor AI prompts..."
    if (Get-PromptFile "$RepoUrl/prompts/cursor/.cursorrules" ".cursorrules") {
        Write-Success "Cursor AI prompts installed (.cursorrules)"
    }
}

function Install-Copilot {
    Write-Info "Installing GitHub Copilot prompts..."
    if (Get-PromptFile "$RepoUrl/prompts/copilot/.github/copilot-instructions.md" ".github/copilot-instructions.md") {
        Write-Success "GitHub Copilot prompts installed (.github/copilot-instructions.md)"
    }
}

function Install-VSCode {
    Write-Info "Installing VS Code AI extension prompts..."
    if (Get-PromptFile "$RepoUrl/prompts/vscode/.vscode/ai-instructions.md" ".vscode/ai-instructions.md") {
        Write-Success "VS Code AI prompts installed (.vscode/ai-instructions.md)"
    }
}

function Install-General {
    Write-Info "Installing general AI assistant context..."
    if (Get-PromptFile "$RepoUrl/prompts/general/bruno-ai-context.md" "bruno-ai-context.md") {
        Write-Success "General AI context installed (bruno-ai-context.md)"
    }
}

function Install-Continue {
    Write-Info "Installing Continue extension prompts..."
    if (-not (Test-Path ".continue")) { New-Item -ItemType Directory -Path ".continue" -Force | Out-Null }
    if (Get-PromptFile "$RepoUrl/prompts/continue/.continue/config.json" ".continue/config.json") {
        Write-Success "Continue extension prompts installed (.continue/config.json)"
    }
}

function Install-Codeium {
    Write-Info "Installing Codeium prompts..."
    if (-not (Test-Path ".codeium")) { New-Item -ItemType Directory -Path ".codeium" -Force | Out-Null }
    if (Get-PromptFile "$RepoUrl/prompts/codeium/.codeium/context.md" ".codeium/context.md") {
        Write-Success "Codeium prompts installed (.codeium/context.md)"
    }
}

# Interactive installation
function Start-InteractiveInstall {
    Write-Host ""
    Write-Info "Bruno AI Assistant Prompts Installer"
    Write-Host ""
    Write-Info "Select which AI assistants you want to install prompts for:"
    Write-Host ""
    Write-Host "1) All assistants (recommended)"
    Write-Host "2) Cursor AI only"
    Write-Host "3) GitHub Copilot only"
    Write-Host "4) VS Code AI extensions only"
    Write-Host "5) General AI assistants (Claude, ChatGPT, etc.)"
    Write-Host "6) Continue extension only"
    Write-Host "7) Codeium only"
    Write-Host "8) Custom selection"
    Write-Host "9) Exit"
    Write-Host ""

    $choice = Read-Host "Enter your choice (1-9)"

    switch ($choice) {
        "1" {
            Write-Info "Installing all AI assistant prompts..."
            New-Directories
            Install-Cursor
            Install-Copilot
            Install-VSCode
            Install-General
            Install-Continue
            Install-Codeium
        }
        "2" { Install-Cursor }
        "3" { New-Directories; Install-Copilot }
        "4" { New-Directories; Install-VSCode }
        "5" { Install-General }
        "6" { Install-Continue }
        "7" { Install-Codeium }
        "8" { Start-CustomSelection }
        "9" { Write-Info "Installation cancelled"; exit 0 }
        default { Write-Error "Invalid choice. Please run the script again."; exit 1 }
    }
}

# Custom selection
function Start-CustomSelection {
    New-Directories
    
    Write-Host ""
    Write-Info "Custom installation - select multiple options (y/n):"
    
    $cursor = Read-Host "Install Cursor AI prompts? (y/n)"
    $copilot = Read-Host "Install GitHub Copilot prompts? (y/n)"
    $vscode = Read-Host "Install VS Code AI extension prompts? (y/n)"
    $general = Read-Host "Install general AI assistant context? (y/n)"
    $continue = Read-Host "Install Continue extension prompts? (y/n)"
    $codeium = Read-Host "Install Codeium prompts? (y/n)"
    
    if ($cursor -eq "y") { Install-Cursor }
    if ($copilot -eq "y") { Install-Copilot }
    if ($vscode -eq "y") { Install-VSCode }
    if ($general -eq "y") { Install-General }
    if ($continue -eq "y") { Install-Continue }
    if ($codeium -eq "y") { Install-Codeium }
}

# Main execution
function Main {
    Write-Info "Bruno AI Assistant Prompts Installer v1.0"
    Write-Host ""
    
    # Check if we're in a Bruno project
    Test-BrunoProject
    
    # Handle command line arguments
    if ($All) {
        New-Directories
        Install-Cursor
        Install-Copilot
        Install-VSCode
        Install-General
        Install-Continue
        Install-Codeium
    }
    elseif ($Cursor) { Install-Cursor }
    elseif ($Copilot) { New-Directories; Install-Copilot }
    elseif ($VSCode) { New-Directories; Install-VSCode }
    elseif ($General) { Install-General }
    elseif ($Continue) { Install-Continue }
    elseif ($Codeium) { Install-Codeium }
    else {
        Start-InteractiveInstall
    }
    
    Write-Host ""
    Write-Success "Installation complete!"
    Write-Host ""
    Write-Info "Next steps:"
    Write-Host "1. Restart your editor to load the new prompt files"
    Write-Host "2. Start coding with your AI assistant"
    Write-Host "3. Check the documentation at: https://github.com/bruno-collections/bruno-ai-assistant-prompts"
    Write-Host ""
    Write-Warning "Note: For Continue extension, you may need to update the API key in .continue/config.json"
}

# Run main function
Main
