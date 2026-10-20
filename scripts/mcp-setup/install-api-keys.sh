#!/usr/bin/env bash
# Serveurs avec clé ou token. Les variables absentes sont ignorées. Sans danger à relancer.
# Usage : ATLASCLOUD_API_KEY=xxx ELEVENLABS_API_KEY=xxx GITHUB_PAT=xxx bash install-api-keys.sh
#   (commence la ligne par une espace pour qu'elle n'aille pas dans l'historique du shell)
# Les clés sont stockées en clair dans ~/.claude.json : ne partage jamais ce fichier.
# Pour changer une clé : claude mcp remove --scope user <nom>, puis relance.
. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
need_claude

if [ -z "${ATLASCLOUD_API_KEY:-}" ]; then skip atlascloud "ATLASCLOUD_API_KEY non définie"
else mcp_step atlascloud npx -- --scope user atlascloud -e ATLASCLOUD_API_KEY="$ATLASCLOUD_API_KEY" -- npx -y atlascloud-mcp; fi

if [ -z "${ELEVENLABS_API_KEY:-}" ]; then skip elevenlabs "ELEVENLABS_API_KEY non définie"
else mcp_step elevenlabs uvx -- --scope user elevenlabs -e ELEVENLABS_API_KEY="$ELEVENLABS_API_KEY" -- uvx elevenlabs-mcp; fi

# Token fine-grained limité aux dépôts utiles. Si l'authentification échoue : image Docker ghcr.io/github/github-mcp-server
if [ -z "${GITHUB_PAT:-}" ]; then skip github "GITHUB_PAT non défini"
else mcp_step github -- --scope user --transport http github https://api.githubcopilot.com/mcp/ -H "Authorization: Bearer $GITHUB_PAT"; fi

summary
