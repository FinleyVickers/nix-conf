#!/usr/bin/env bash
set -euo pipefail

FLAKE_FEATURE_FLAGS=(--option experimental-features "nix-command flakes")

repo_root() {
  local script_dir
  script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
  cd -- "${script_dir}/.." && pwd
}

flake_ref() {
  local root="${1:-$(repo_root)}"
  local host="${2:-${HOST:-nixos}}"
  printf '%s#%s\n' "${root}" "${host}"
}

home_ref() {
  local root="${1:-$(repo_root)}"
  local username="${2:-${USERNAME:-${USER:-finleyv}}}"
  printf '%s#%s\n' "${root}" "${username}"
}

require_command() {
  local command_name="$1"
  if ! command -v "${command_name}" >/dev/null 2>&1; then
    echo "Missing required command: ${command_name}" >&2
    exit 1
  fi
}

print_step() {
  printf '\n==> %s\n' "$1"
}

stub_legacy_nixos_config() {
  local root="${1:-$(repo_root)}"
  local host="${2:-${HOST:-nixos}}"
  local target="/etc/nixos/configuration.nix"
  local repo_config="${root}/configuration.nix"
  local resolved_target
  local resolved_repo_config
  local backup_file
  local tmp_file

  if [ ! -e "${target}" ]; then
    return 0
  fi

  resolved_target="$(readlink -f -- "${target}")"
  resolved_repo_config="$(readlink -f -- "${repo_config}")"

  if [ "${resolved_target}" = "${resolved_repo_config}" ]; then
    print_step "Leaving ${target}; it points at the flake configuration"
    return 0
  fi

  backup_file="${target}.pre-flake-backup-$(date +%Y%m%d-%H%M%S)"
  tmp_file="$(mktemp)"

  cat > "${tmp_file}" <<EOF
# This system is managed by the flake at:
#
#   ${root}
#
# Rebuild with:
#
#   sudo nixos-rebuild switch --flake ${root}#${host}
#
# This stub intentionally does not define a NixOS system. It exists only to
# document that /etc/nixos is not the source of truth for this machine.

{ ... }:

{
  assertions = [
    {
      assertion = false;
      message = ''
        /etc/nixos/configuration.nix is only a stub.

        Use:
          sudo nixos-rebuild switch --flake ${root}#${host}
      '';
    }
  ];
}
EOF

  print_step "Stubbing legacy ${target}"
  sudo cp -- "${target}" "${backup_file}"
  sudo install -m 0644 -- "${tmp_file}" "${target}"
  rm -f -- "${tmp_file}"
}
