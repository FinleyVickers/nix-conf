#!/usr/bin/env bash
set -euo pipefail

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

