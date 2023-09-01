#!/bin/bash

# Catch exit signal (CTRL + C), to terminate the whole script.
trap "exit" INT

# Terminate script on error.
set -e

# Constant variable of the scripts' working directory to use for relative paths.
SCRIPT_DIRECTORY=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Import functions and constant variables.
source "$SCRIPT_DIRECTORY/../functions.sh"
source "$SCRIPT_DIRECTORY/../../core/constants.sh"

# Constant variable for the terminal tools to install.
TERMINAL_TOOLS="bat exa rm-improved xcp eva zoxide fd sd xh topgrade"

# Check if at least one terminal tool is not installed.
if ! are_packages_installed "$TERMINAL_TOOLS" "$AUR_PACKAGE_MANAGER"; then
    log_info "Installing terminal tools..."

    # Installing terminal tools.
    install_packages "$TERMINAL_TOOLS" "$AUR_PACKAGE_MANAGER"
fi
