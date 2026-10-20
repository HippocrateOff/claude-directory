#!/usr/bin/env bash
# Serveurs qui demandent une clé API ou un token. Remplis les variables puis lance :
#   ATLASCLOUD_API_KEY=xxx ELEVENLABS_API_KEY=xxx GITHUB_PAT=xxx bash install-api-keys.sh
# Les variables absentes sont ignorées. Relançable : un serveur déjà présent n'est pas réajouté.
# Ne mets jamais ces clés dans un fichier partagé ou un dépôt.
# Astuce : commence la ligne par une espace pour qu'elle n'aille pas dans l'historique du shell
# (bash avec HISTCONTROL=ignorespace, zsh avec setopt HIST_IGNORE_SPACE).

have() { command -v "$1" >/dev/null 2>&1; }

if ! have claude; then
  echo "ERREUR : 'claude' (Claude Code) est introuvable. Installe-le d'abord."
  exit 1
fi

# add NOM VARIABLE PREREQUIS -- args de 'claude mcp add' (sans --scope ni nom)
add() {
  local name="$1" var="$2" req="$3"; shift 4
  if [ -z "${!var}" ]; then
    echo "[SKIP] $name : $var non définie"; return
  fi
  if [ -n "$req" ] && ! have "$req"; then
    echo "[SKIP] $name : prérequis manquant ($req)"; return
  fi
  if claude mcp get "$name" >/dev/null 2>&1; then
    echo "[OK]   $name : déjà enregistré (pour changer la clé : claude mcp remove --scope user $name)"; return
  fi
  if claude mcp add --scope user "$name" "$@"; then
    echo "[OK]   $name"
  else
    echo "[FAIL] $name"
  fi
}

# Atlas Cloud (Kling, Seedance, Veo, Suno…) : lit ATLASCLOUD_API_KEY
add atlascloud ATLASCLOUD_API_KEY npx -- \
  -e ATLASCLOUD_API_KEY="$ATLASCLOUD_API_KEY" -- npx -y atlascloud-mcp

# ElevenLabs : le serveur exige ELEVENLABS_API_KEY
add elevenlabs ELEVENLABS_API_KEY uvx -- \
  -e ELEVENLABS_API_KEY="$ELEVENLABS_API_KEY" -- uvx elevenlabs-mcp

# GitHub (serveur distant officiel) : token fine-grained limité aux dépôts utiles.
# Si l'auth échoue : image Docker ghcr.io/github/github-mcp-server
add github GITHUB_PAT "" -- \
  --transport http https://api.githubcopilot.com/mcp/ -H "Authorization: Bearer $GITHUB_PAT"

echo
claude mcp list
