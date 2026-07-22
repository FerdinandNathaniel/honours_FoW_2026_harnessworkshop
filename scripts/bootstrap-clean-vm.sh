#!/usr/bin/env bash
set -euo pipefail

APM_VERSION="0.26.0"
TARGET_RUNTIME="copilot"
WORKSPACE_ROOT=""
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
  --workspace-root <path>  VS Code workspace root for symlinks (default: auto-detect)
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

check_python() {
  local min_version="3.11"
  command -v python3 >/dev/null 2>&1 || die "python3 is required. Install Python $min_version or later."
  local version
  version=$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
  local major minor
  major=$(echo "$version" | cut -d. -f1)
  minor=$(echo "$version" | cut -d. -f2)
  if [[ "$major" -lt 3 ]] || { [[ "$major" -eq 3 ]] && [[ "$minor" -lt 11 ]]; }; then
    die "Python $min_version+ is required. Found Python $version. Install Python $min_version or later."
  fi
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

link_to_workspace_root() {
  local src_root="$1"
  local ws_root="$2"

  if [[ "$src_root" == "$ws_root" ]]; then
    return 0
  fi

  log "Workspace root ($ws_root) differs from project root"
  log "Creating symlinks so Copilot Chat discovers the deployed artifacts"

  for dir in .github .agents; do
    local src="$src_root/$dir"
    local dst="$ws_root/$dir"

    if [[ ! -d "$src" ]]; then
      log "  skipping $dir (not found in project root)"
      continue
    fi

    if [[ -L "$dst" ]]; then
      local link_target
      link_target=$(readlink "$dst")
      if [[ "$link_target" == "$src" ]]; then
        log "  $dst already linked correctly"
        continue
      fi
      log "  replacing stale symlink $dst"
      run_cmd rm "$dst"
    elif [[ -e "$dst" ]]; then
      log "  $dst already exists as a regular file/directory — skipping (remove it manually if you want a symlink)"
      continue
    fi

    run_cmd ln -s "$src" "$dst"
    log "  $dst -> $src"
  done
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
      --workspace-root)
        WORKSPACE_ROOT="$2"
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

  check_python
  require_command curl
  install_apm_pinned

  log "Deploying workshop package to $TARGET_RUNTIME"
  pushd "$PROJECT_ROOT" >/dev/null
  run_cmd apm install --target "$TARGET_RUNTIME"
  popd >/dev/null

  if [[ -z "$WORKSPACE_ROOT" ]]; then
    WORKSPACE_ROOT="$HOME"
  fi
  link_to_workspace_root "$PROJECT_ROOT" "$WORKSPACE_ROOT"

  log "Bootstrap complete — workshop sources deployed from .apm/"
}

main "$@"
