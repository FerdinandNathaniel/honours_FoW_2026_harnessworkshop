#!/usr/bin/env bash
set -euo pipefail

APM_VERSION="0.24.0"
TARGET_REPO="FerdinandNathaniel/honours_FoW_2026_harnessworkshop"
TARGET_RUNTIME="copilot"
NON_INTERACTIVE=0
DRY_RUN=0

usage() {
  cat <<'EOF'
Usage: bootstrap-clean-vm.sh [options]

Bootstrap a clean machine with APM and the workshop framework.

Options:
  --target <runtime>       APM target runtime (default: copilot)
  --apm-version <version>  Required APM CLI version (default: 0.24.0)
  --non-interactive        Fail instead of prompting for input
  --dry-run                Print commands instead of executing
  -h, --help               Show this help message
EOF
}

log() {
  echo "[bootstrap] $*"
}

warn() {
  echo "[bootstrap][warn] $*" >&2
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
      --non-interactive)
        NON_INTERACTIVE=1
        shift
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

  log "Installing workshop package $TARGET_REPO (target: $TARGET_RUNTIME)"
  run_cmd apm install -g "$TARGET_REPO" --target "$TARGET_RUNTIME"

  log "Bootstrap complete — all workshop skills, prompts, and agents installed"
}

main "$@"
