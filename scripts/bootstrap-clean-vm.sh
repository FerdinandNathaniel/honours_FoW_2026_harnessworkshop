#!/usr/bin/env bash
set -euo pipefail

APM_VERSION="0.26.0"
TARGET_RUNTIME="copilot"
DRY_RUN=0
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd)"

usage() {
  cat <<'EOF'
Usage: bootstrap-clean-vm.sh [options]

Bootstrap a clean machine with APM and the workshop framework.

Options:
  --target <runtime>       APM target runtime (default: copilot)
  --apm-version <version>  Required APM CLI version (default: 0.26.0)
  --dry-run                Print commands instead of executing
  -h, --help               Show this help message
EOF
}

log() {
  echo "[bootstrap] $*"
}

die() {
  echo "[bootstrap][error] $*" >&2
  exit 1
}

run_cmd() {
  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "[dry-run] $*"
    return 0
  fi
  "$@"
}

require_command() {
  local cmd="$1"
  command -v "$cmd" >/dev/null 2>&1 || die "Required command '$cmd' is missing"
}

apm_version_value() {
  apm --version | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' | head -n1
}

install_apm_pinned() {
  local current=""
  if command -v apm >/dev/null 2>&1; then
    current="$(apm_version_value)"
  fi

  if [[ "$current" == "$APM_VERSION" ]]; then
    log "APM CLI $APM_VERSION already installed"
    return 0
  fi

  log "Installing APM CLI v$APM_VERSION into ~/.local/bin"
  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "[dry-run] curl -sSL https://aka.ms/apm-unix | VERSION=v$APM_VERSION APM_INSTALL_DIR=$HOME/.local/bin sh"
    return 0
  else
    curl -sSL https://aka.ms/apm-unix | VERSION="v$APM_VERSION" APM_INSTALL_DIR="$HOME/.local/bin" sh
  fi

  export PATH="$HOME/.local/bin:$PATH"
  command -v apm >/dev/null 2>&1 || die "apm not found after installation"

  local installed
  installed="$(apm_version_value)"
  [[ "$installed" == "$APM_VERSION" ]] || die "Installed apm version '$installed' does not match required '$APM_VERSION'"
}

main() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --target)
        TARGET_RUNTIME="$2"
        shift 2
        ;;
      --apm-version)
        APM_VERSION="$2"
        shift 2
        ;;
      --dry-run)
        DRY_RUN=1
        shift
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        die "Unknown option: $1"
        ;;
    esac
  done

  require_command curl
  install_apm_pinned

  log "Deploying workshop package to $TARGET_RUNTIME"
  pushd "$PROJECT_ROOT" >/dev/null
  run_cmd apm install --target "$TARGET_RUNTIME"
  popd >/dev/null

  log "Bootstrap complete — workshop sources deployed from .apm/"
}

main "$@"
