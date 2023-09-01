#!/bin/bash

# Catch exit signal (CTRL + C), to terminate the whole script.
trap "exit" INT

# Terminate script on error.
set -e

# Import functions and constant variables.
source ../functions.sh
source ../../core/constants.sh

# Constant variables for installing and configuring the paru AUR helper.
PARU_DIRECTORY="paru"
PARU_GIT_URL="https://aur.archlinux.org/paru.git"
PACMAN_CONFIGURATION="/etc/pacman.conf"
PARU_CONFIGURATION="/etc/paru.conf"

# Install paru AUR helper.
if command -v "$AUR_PACKAGE_MANAGER" &>/dev/null; then
    log_warning "$AUR_PACKAGE_MANAGER AUR helper, is already installed!"
else

    # Delete old paru directory, if it exists.
    if [ -d "$PARU_DIRECTORY" ]; then
        log_info "Deleting old $PARU_DIRECTORY directory..."
        rm -rf "$PARU_DIRECTORY"
    fi

    # Delete rust package manager, if it exists.
    if are_packages_installed "rust" "$ARCH_PACKAGE_MANAGER"; then
        log_info "Deleting rust package manager..."
        sudo "$ARCH_PACKAGE_MANAGER" -R --noconfirm rust
    fi

    # Install rustup package.
    install_packages "rustup" "$ARCH_PACKAGE_MANAGER"

    # Check if rustup is already at stable version.
    current_rustup_version=$(rustup show active-toolchain)
    if [[ "$current_rustup_version" != "stable"* ]]; then

        # Changing to stable rust version.
        log_info "Changing to stable rust version..."
        rustup default stable
    fi

    # Proceed with installation.
    log_info "Installing $AUR_PACKAGE_MANAGER AUR helper..."
    git clone $PARU_GIT_URL && cd $PARU_DIRECTORY && makepkg -si --noconfirm && cd .. && rm -rf $PARU_DIRECTORY
fi

# Configuring paru AUR helper.
if ! grep -q '^Color' "$PACMAN_CONFIGURATION" || ! grep -qxF 'SkipReview' "$PARU_CONFIGURATION"; then
    log_info "Configuring $AUR_PACKAGE_MANAGER AUR helper..."
fi

# Enabling colors in terminal.
if ! grep -q '^Color' $PACMAN_CONFIGURATION; then
    log_info "Enabling colors in terminal..."
    sudo sed -i '/^#.*Color/s/^#//' $PACMAN_CONFIGURATION
fi

# Skipping review messages.
if ! grep -qxF 'SkipReview' $PARU_CONFIGURATION; then
    log_info "Skipping review messages..."
    echo 'SkipReview' | sudo tee -a $PARU_CONFIGURATION >/dev/null
fi