#!/usr/bin/env bash
# Serveurs optionnels (prérequis lourds ou usage ciblé). Sans danger à relancer.
# Usage : bash install-optional.sh
# Variables : BLENDER_FULL=1 pour ajouter RFingAdam/mcp-blender (218 outils, AGPL-3.0)
. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
need_claude

R_PKGS='c("gsDesign","gsDesign2","graphicalMCP","jsonlite","officer","rmarkdown")'

echo "=== Essais cliniques (clinical-trial-design) — R >= 4.2 requis ==="
if ! have Rscript; then
  skip clinical-trial-design "prérequis manquant : Rscript (R >= 4.2)"
elif ! Rscript -e "q(status = as.integer(getRversion() < '4.2' || !all(sapply($R_PKGS, requireNamespace, quietly = TRUE))))" >/dev/null 2>&1; then
  skip clinical-trial-design "R < 4.2 ou paquets R manquants. Lance : R -e 'install.packages($R_PKGS)'"
elif has_plugin "clinical-trial-design@wei-ai-lab"; then
  ok "clinical-trial-design (déjà installé)"
else
  cmd_step ctd-marketplace -- claude plugin marketplace add wei-ai-lab/clinical-trial-design
  cmd_step ctd-plugin -- claude plugin install clinical-trial-design@wei-ai-lab
fi

echo "=== Recherche (gratuit, sans clé) ==="
# openresearch-mcp : web, PDF, OpenAlex, Hacker News, Stack Overflow, dépôts, transcriptions YouTube
mcp_step openresearch uvx -- --scope user openresearch -- uvx openresearch-mcp --stdio

echo "=== Design ==="
mcp_step figma-mcp-go npx -- --scope user figma-mcp-go -- npx -y @vkhanhqui/figma-mcp-go@latest
echo "  -> figma-mcp-go : importe aussi le plugin (Figma Desktop > Plugins > Development > Import plugin from manifest, manifest.json du plugin.zip des releases)."

echo "=== Géospatial (QGIS 3.28+ et plugin 'QGIS MCP' requis) ==="
mcp_step qgis uvx -- --scope user qgis -- uvx --from https://github.com/nkarasiak/qgis-mcp/archive/refs/heads/main.zip qgis-mcp-server
echo "  -> qgis : installe le plugin dans QGIS (Extensions > Installer/Gérer les extensions > 'QGIS MCP')."

echo "=== HyperFrames / Recreator ==="
echo "  (nécessite le CLI HyperFrames : npx hyperframes)"
mcp_step hyperframes uvx -- --scope user hyperframes -- uvx timeverse-hyperframes-mcp
have recreator-mcp || cmd_step recreator-pip pip -- pip install recreator-mcp
mcp_step recreator recreator-mcp -- --scope user recreator -- recreator-mcp

echo "=== Blender complet (facultatif) ==="
if [ "${BLENDER_FULL:-0}" = "1" ]; then
  have mcp-blender || cmd_step mcp-blender-pip pip git -- pip install "mcp-blender @ git+https://github.com/RFingAdam/mcp-blender.git"
  mcp_step blender-full mcp-blender -- --scope user blender-full -- mcp-blender --port 9876
  echo "  -> n'active qu'UN seul addon Blender à la fois (mcp-for-blender et mcp-blender utilisent tous deux le port 9876)."
else
  skip blender-full "désactivé (BLENDER_FULL=1 pour l'installer ; le paquet PyPI 'mcp-blender' n'est pas celui-ci)"
fi

echo "=== CatCut (Windows + Kdenlive, Python 3.11-3.12) ==="
if ! is_windows; then
  skip catcut "CatCut est annoncé pour Windows uniquement"
elif ! have uv; then
  skip catcut "prérequis manquant : uv"
else
  have catcut || cmd_step catcut-install uv -- uv tool install --python 3.12 catcut
  have catcut && { echo "--- Config à copier dans ton client MCP ---"; catcut config show-mcp; }
fi

summary
