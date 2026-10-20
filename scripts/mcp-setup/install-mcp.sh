#!/usr/bin/env bash
# Noyau : serveurs vérifiés, sans clé API. Sans danger à relancer.
# Usage : bash install-mcp.sh
. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
need_claude

echo "=== A. Recherche et science (gratuit, sans compte) ==="
mcp_step parallel-search -- --scope user --transport http parallel-search https://search.parallel.ai/mcp
mcp_step idc -- --scope user --transport http idc https://api.imaging.datacommons.cancer.gov/mcp
mcp_step keyless-research uvx -- --scope user keyless-research -- uvx keyless-research-mcp
mcp_step clinicaltrials npx -- --scope user clinicaltrials -- npx -y clinicaltrialsgov-mcp-server

echo "=== B. Audiovisuel ==="
if ! have ffmpeg; then
  skip kinocut "prérequis manquant : ffmpeg"
else
  have kino || cmd_step kinocut-pip pip -- pip install kinocut
  have kino || echo "  -> 'kino' introuvable après l'installation : ajoute ~/.local/bin à ton PATH puis relance."
  mcp_step kinocut kino -- --scope user kinocut -- kino --mcp
fi
mcp_step blender uvx -- --scope user blender -- uvx mcp-for-blender
# HyperFrames (open source, Apache-2.0) : plugin Claude Code officiel de HeyGen
if has_plugin "hyperframes@hyperframes"; then
  ok "hyperframes-plugin (déjà installé)"
else
  cmd_step hyperframes-marketplace -- claude plugin marketplace add heygen-com/hyperframes
  cmd_step hyperframes-plugin -- claude plugin install hyperframes@hyperframes
fi
# Skill de montage calé sur les beats (FFmpeg), installé pour l'utilisateur (-g), sans question (-y)
cmd_step beat-sync-skill npx -- npx -y skills add https://github.com/ecliptic-ai/skills \
  --skill beat-sync-video-editing -g -a claude-code -y

echo "=== C. Connexion par compte (OAuth : authentifier ensuite avec /mcp) ==="
mcp_step vulk -- --scope user --transport http vulk https://mcp.vulk.dev/mcp
mcp_step Canva -- --scope user --transport http Canva https://mcp.canva.com/mcp
mcp_step figma -- --scope user --transport http figma https://mcp.figma.com/mcp
mcp_step Zapier-MCP -- --scope user --transport http Zapier-MCP https://mcp.zapier.com/api/v1/connect

summary
echo
echo "Suite : GUIDE.md (OAuth via /mcp, Remotion via skills, install-optional.sh, install-api-keys.sh)."
