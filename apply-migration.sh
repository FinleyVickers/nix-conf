#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="/home/finleyv/nixos-flake"
TARGET_DIR="/etc/nixos"
BACKUP_DIR="/etc/nixos.backup-$(date +%Y%m%d-%H%M%S)"

echo "Backing up ${TARGET_DIR} to ${BACKUP_DIR}"
cp -a "${TARGET_DIR}" "${BACKUP_DIR}"

echo "Copying flake layout into ${TARGET_DIR}"
install -d "${TARGET_DIR}/modules"
cp -f "${SOURCE_DIR}/flake.nix" "${TARGET_DIR}/flake.nix"
cp -f "${SOURCE_DIR}/flake.lock" "${TARGET_DIR}/flake.lock"
cp -f "${SOURCE_DIR}/configuration.nix" "${TARGET_DIR}/configuration.nix"
cp -f "${SOURCE_DIR}/hardware-configuration.nix" "${TARGET_DIR}/hardware-configuration.nix"
cp -f "${SOURCE_DIR}/home.nix" "${TARGET_DIR}/home.nix"
cp -f "${SOURCE_DIR}/modules/hardware.nix" "${TARGET_DIR}/modules/hardware.nix"
cp -f "${SOURCE_DIR}/modules/networking.nix" "${TARGET_DIR}/modules/networking.nix"
cp -f "${SOURCE_DIR}/modules/services.nix" "${TARGET_DIR}/modules/services.nix"

echo "Building the new flake generation as the next boot configuration"
nixos-rebuild boot --flake "${TARGET_DIR}#nixos"

echo "Reboot to activate the new generation cleanly"
