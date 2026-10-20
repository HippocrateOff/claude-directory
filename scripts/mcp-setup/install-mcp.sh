#!/usr/bin/env bash
# Installation des serveurs MCP pour Claude Code (v2)
# Usage : bash install-mcp.sh        (dans un terminal normal)
# Chaque ligne vérifie ses prérequis et saute proprement si un outil manque.
# Relançable : un serveur déjà enregistré est compté OK sans être réajouté.

have() { command -v "$1" >/dev/null 2>&1; }
OK=(); SKIP=(); FAIL=()

if ! have claude; then
  echo "ERREUR : 'claude' (Claude Code) est introuvable. Installe-le d'abord."
  exit 1
fi

# run NOM PREREQUIS... -- commande...
run() {
  local name="$1"; shift
  local reqs=()
  while [ "$1" != "--" ]; do reqs+=("$1"); shift; done
  shift
  for r in "${reqs[@]}"; do
    if ! have "$r"; then
      echo "[SKIP] $name : prérequis manquant ($r)"; SKIP+=("$name ($r)"); return
    fi
  done
  echo "[....] $name"
  if "$@"; then OK+=("$name"); else echo "[FAIL] $name"; FAIL+=("$name"); fi
}

# mcp_add NOM args... : 'claude mcp add --scope user' qui ignore un serveur déjà présent
mcp_add() {
  local name="$1"; shift
  if claude mcp get "$name" >/dev/null 2>&1; then
    echo "       déjà enregistré"; return 0
  fi
  claude mcp add --scope user "$name" "$@"
}

echo "=== A. Gratuit, sans clé ni compte ==="
run parallel-search -- mcp_add parallel-search --transport http https://search.parallel.ai/mcp
run idc -- mcp_add idc --transport http https://api.imaging.datacommons.cancer.gov/mcp
run keyless-research uvx -- mcp_add keyless-research -- uvx keyless-research-mcp
run clinicaltrials npx -- mcp_add clinicaltrials -- npx -y clinicaltrialsgov-mcp-server

echo "=== Audiovisuel ==="
if have ffmpeg && have pip; then
  have kino || run kinocut-pip pip -- pip install kinocut
  have kino || echo "       'kino' absent du PATH (souvent ~/.local/bin) : ajoute-le puis relance"
  run kinocut kino -- mcp_add kinocut -- kino --mcp
else
  echo "[SKIP] kinocut : ffmpeg ou pip manquant"; SKIP+=("kinocut (ffmpeg/pip)")
fi
run blender uvx -- mcp_add blender -- uvx mcp-for-blender
run remotion npx -- mcp_add remotion -- npx -y @remotion/mcp
run hyperframes uvx -- mcp_add hyperframes -- uvx timeverse-hyperframes-mcp
have pip && run recreator-pip pip -- pip install recreator-mcp   # installé, pas branché
run beat-sync-skill npx -- npx -y skills add https://github.com/ecliptic-ai/skills --skill beat-sync-video-editing

if have uv; then
  have catcut || run catcut-install uv -- uv tool install catcut
  have catcut && { echo "--- Config CatCut à copier (nécessite Kdenlive) ---"; catcut config show-mcp; }
else
  echo "[SKIP] catcut : uv manquant"; SKIP+=("catcut (uv)")
fi

echo "=== B. Connexion par compte (OAuth : authentifier ensuite avec /mcp) ==="
run vulk -- mcp_add vulk --transport http https://mcp.vulk.dev/mcp
run canva -- mcp_add Canva --transport http https://mcp.canva.com/mcp
run figma -- mcp_add figma --transport http https://mcp.figma.com/mcp
run zapier -- mcp_add Zapier-MCP --transport http https://mcp.zapier.com/api/v1/connect

echo
echo "=== Résumé ==="
echo "OK   : ${OK[*]}"
echo "SKIP : ${SKIP[*]}"
echo "FAIL : ${FAIL[*]}"
echo
claude mcp list
echo
echo "Suite : voir GUIDE.md (OAuth via /mcp, clés API, connecteurs manuels)."
