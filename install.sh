#!/bin/bash

# Bruno AI Assistant Prompts Installer
# This script installs AI assistant prompt files for Bruno API Client projects

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
REPO_URL="https://raw.githubusercontent.com/bruno-collections/bruno-ai-assistant-prompts/main"
TEMP_DIR="/tmp/bruno-ai-prompts"

# Print colored output
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check if we're in a Bruno project
check_bruno_project() {
    if [[ ! -f "bruno.json" ]]; then
        print_error "bruno.json not found. Please run this script from a Bruno project directory."
        exit 1
    fi
    print_success "Bruno project detected"
}

# Create necessary directories
create_directories() {
    print_info "Creating directories..."
    mkdir -p .github
    mkdir -p .vscode
    print_success "Directories created"
}

# Download and install prompt files
install_cursor() {
    print_info "Installing Cursor AI prompts..."
    curl -fsSL "${REPO_URL}/prompts/cursor/.cursorrules" -o .cursorrules
    print_success "Cursor AI prompts installed (.cursorrules)"
}

install_copilot() {
    print_info "Installing GitHub Copilot prompts..."
    curl -fsSL "${REPO_URL}/prompts/copilot/.github/copilot-instructions.md" -o .github/copilot-instructions.md
    print_success "GitHub Copilot prompts installed (.github/copilot-instructions.md)"
}

install_vscode() {
    print_info "Installing VS Code AI extension prompts..."
    curl -fsSL "${REPO_URL}/prompts/vscode/.vscode/ai-instructions.md" -o .vscode/ai-instructions.md
    print_success "VS Code AI prompts installed (.vscode/ai-instructions.md)"
}

install_general() {
    print_info "Installing general AI assistant context..."
    curl -fsSL "${REPO_URL}/prompts/general/bruno-ai-context.md" -o bruno-ai-context.md
    print_success "General AI context installed (bruno-ai-context.md)"
}

install_continue() {
    print_info "Installing Continue extension prompts..."
    mkdir -p .continue
    curl -fsSL "${REPO_URL}/prompts/continue/.continue/config.json" -o .continue/config.json
    print_success "Continue extension prompts installed (.continue/config.json)"
}

install_codeium() {
    print_info "Installing Codeium prompts..."
    mkdir -p .codeium
    curl -fsSL "${REPO_URL}/prompts/codeium/.codeium/context.md" -o .codeium/context.md
    print_success "Codeium prompts installed (.codeium/context.md)"
}

# Interactive installation
interactive_install() {
    echo
    print_info "Bruno AI Assistant Prompts Installer"
    echo
    print_info "Select which AI assistants you want to install prompts for:"
    echo
    echo "1) All assistants (recommended)"
    echo "2) Cursor AI only"
    echo "3) GitHub Copilot only"
    echo "4) VS Code AI extensions only"
    echo "5) General AI assistants (Claude, ChatGPT, etc.)"
    echo "6) Continue extension only"
    echo "7) Codeium only"
    echo "8) Custom selection"
    echo "9) Exit"
    echo

    read -p "Enter your choice (1-9): " choice

    case $choice in
        1)
            print_info "Installing all AI assistant prompts..."
            create_directories
            install_cursor
            install_copilot
            install_vscode
            install_general
            install_continue
            install_codeium
            ;;
        2)
            install_cursor
            ;;
        3)
            create_directories
            install_copilot
            ;;
        4)
            create_directories
            install_vscode
            ;;
        5)
            install_general
            ;;
        6)
            install_continue
            ;;
        7)
            install_codeium
            ;;
        8)
            custom_selection
            ;;
        9)
            print_info "Installation cancelled"
            exit 0
            ;;
        *)
            print_error "Invalid choice. Please run the script again."
            exit 1
            ;;
    esac
}

# Custom selection
custom_selection() {
    create_directories
    
    echo
    print_info "Custom installation - select multiple options (y/n):"
    
    read -p "Install Cursor AI prompts? (y/n): " cursor
    read -p "Install GitHub Copilot prompts? (y/n): " copilot
    read -p "Install VS Code AI extension prompts? (y/n): " vscode
    read -p "Install general AI assistant context? (y/n): " general
    read -p "Install Continue extension prompts? (y/n): " continue
    read -p "Install Codeium prompts? (y/n): " codeium
    
    [[ $cursor == "y" ]] && install_cursor
    [[ $copilot == "y" ]] && install_copilot
    [[ $vscode == "y" ]] && install_vscode
    [[ $general == "y" ]] && install_general
    [[ $continue == "y" ]] && install_continue
    [[ $codeium == "y" ]] && install_codeium
}

# Command line installation
cmd_install() {
    case $1 in
        --all)
            create_directories
            install_cursor
            install_copilot
            install_vscode
            install_general
            install_continue
            install_codeium
            ;;
        --cursor)
            install_cursor
            ;;
        --copilot)
            create_directories
            install_copilot
            ;;
        --vscode)
            create_directories
            install_vscode
            ;;
        --general)
            install_general
            ;;
        --continue)
            install_continue
            ;;
        --codeium)
            install_codeium
            ;;
        *)
            echo "Usage: $0 [--all|--cursor|--copilot|--vscode|--general|--continue|--codeium]"
            echo "Run without arguments for interactive installation"
            exit 1
            ;;
    esac
}

# Main execution
main() {
    print_info "Bruno AI Assistant Prompts Installer v1.0"
    echo
    
    # Check if we're in a Bruno project
    check_bruno_project
    
    # Check for command line arguments
    if [[ $# -eq 0 ]]; then
        interactive_install
    else
        cmd_install $1
    fi
    
    echo
    print_success "Installation complete!"
    echo
    print_info "Next steps:"
    echo "1. Restart your editor to load the new prompt files"
    echo "2. Start coding with your AI assistant"
    echo "3. Check the documentation at: https://github.com/bruno-collections/bruno-ai-assistant-prompts"
    echo
    print_warning "Note: For Continue extension, you may need to update the API key in .continue/config.json"
}

# Run main function
main "$@"
