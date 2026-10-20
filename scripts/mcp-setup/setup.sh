#!/usr/bin/env bash
# Registers research + video-editing MCP servers for Claude Code at user scope.
# Safe to re-run: servers that are already registered are skipped.
set -euo pipefail

need() {
  command -v "$1" >/dev/null 2>&1 || { echo "missing dependency: $1" >&2; exit 1; }
}
need claude

add() {
  local name="$1"; shift
  if claude mcp get "$name" >/dev/null 2>&1; then
    echo "skip  $name (already registered)"
  else
    claude mcp add --scope user "$name" "$@"
    echo "added $name"
  fi
}

# Research / data
add parallel-search --transport http https://search.parallel.ai/mcp
add idc --transport http https://api.imaging.datacommons.cancer.gov/mcp
add keyless-research -- uvx keyless-research-mcp
add clinicaltrials -- npx -y clinicaltrialsgov-mcp-server

# Video editing / 3D / motion
if ! command -v kino >/dev/null 2>&1; then
  pip install kinocut
fi
add kinocut -- kino --mcp
add blender -- uvx mcp-for-blender
add remotion -- npx -y @remotion/mcp

# Free alternative to Beat-Cut: beat-synced editing skill (FFmpeg)
npx -y skills add https://github.com/ecliptic-ai/skills --skill beat-sync-video-editing

echo
claude mcp list
