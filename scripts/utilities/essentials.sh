#!/bin/bash

# Catch exit signal (CTRL + C), to terminate the whole script.
trap "exit" INT

# Terminate script on error.
set -e

# Constant variable of the scripts' working directory to use for relative paths.
ESSENTIALS_SCRIPT_DIRECTORY=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Import functions.
source "$ESSENTIALS_SCRIPT_DIRECTORY/../helpers/functions.sh"

# Update system.
update_system

# Essential packages.
ESSENTIAL_PACKAGES="base-devel git networkmanager neovim btop"

# Install essential packages.
if ! are_packages_installed "$ESSENTIAL_PACKAGES" "$ARCH_PACKAGE_MANAGER"; then
    log_info "Installing essential packages..."
    install_packages "$ESSENTIAL_PACKAGES" "$ARCH_PACKAGE_MANAGER"
fi

# Array of essential scripts.
essential_scripts=(
    $ESSENTIALS_SCRIPT_DIRECTORY/../helpers/essentials/aur.sh
    $ESSENTIALS_SCRIPT_DIRECTORY/../helpers/essentials/information.sh
    $ESSENTIALS_SCRIPT_DIRECTORY/../helpers/essentials/mirrors.sh
    $ESSENTIALS_SCRIPT_DIRECTORY/../helpers/essentials/terminal.sh
    $ESSENTIALS_SCRIPT_DIRECTORY/../helpers/essentials/prompt.sh
    $ESSENTIALS_SCRIPT_DIRECTORY/../helpers/essentials/fonts.sh
    $ESSENTIALS_SCRIPT_DIRECTORY/../helpers/essentials/shell.sh
)

# Give execution permission to all needed scripts.
give_execution_permission_to_scripts "${essential_scripts[@]}" "Giving execution permission to all essential scripts..."

# Install and configure AUR helper.
sh $ESSENTIALS_SCRIPT_DIRECTORY/../helpers/essentials/aur.sh

# Install and configure system information tool.
sh $ESSENTIALS_SCRIPT_DIRECTORY/../helpers/essentials/information.sh

# Install and configure mirror list manager.
sh $ESSENTIALS_SCRIPT_DIRECTORY/../helpers/essentials/mirrors.sh

# Install terminal tools.
sh $ESSENTIALS_SCRIPT_DIRECTORY/../helpers/essentials/terminal.sh

# Install and configure prompt.
sh $ESSENTIALS_SCRIPT_DIRECTORY/../helpers/essentials/prompt.sh

# Install fonts.
sh $ESSENTIALS_SCRIPT_DIRECTORY/../helpers/essentials/fonts.sh

# Install and configure shell.
sh $ESSENTIALS_SCRIPT_DIRECTORY/../helpers/essentials/shell.sh

# TODO: Restart device to apply changes and rerun script.
