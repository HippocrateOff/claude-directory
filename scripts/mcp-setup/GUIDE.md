# Guide pas à pas : connecteurs Claude + Claude Code

Fichiers du kit : `install-mcp.sh`, `install-api-keys.sh`, `CLAUDE.md`, ce guide.
Rien n'est installé tant que tu n'as pas lancé ces étapes sur ta machine.

## Étape 0 : prérequis (une fois)

- Claude Code installé (`claude --version`).
- Node.js 22.16+ (`node -v`), Python 3.11+ (`python3 --version`) et `pip`.
- [uv](https://docs.astral.sh/uv/), qui fournit `uvx` (`uv --version`).
- ffmpeg (`ffmpeg -version`) : indispensable à Kinocut et au skill beat-sync.
- Facultatifs : Blender 3.0+ (pour le MCP Blender), Kdenlive (pour CatCut).

## Étape 1 : serveurs sans clé (Claude Code)

Dans un terminal normal, depuis le dossier du kit :

```bash
bash install-mcp.sh
```

Le résumé final liste OK / SKIP / FAIL. Un SKIP veut dire qu'un prérequis manque : installe-le puis relance le script. Le relancer est sans danger, car un serveur déjà enregistré est compté OK.

Si `kino` reste introuvable après `pip install kinocut`, ajoute `~/.local/bin` à ton `PATH`.

## Étape 2 : authentifier les serveurs OAuth

Ouvre Claude Code (`claude`), tape `/mcp`, choisis chaque serveur (`vulk`, `Canva`, `figma`, `Zapier-MCP`), puis **Authenticate** et valide dans le navigateur. Le jeton est conservé jusqu'à son expiration.

## Étape 3 : vérifier

`claude mcp list` : chaque serveur doit afficher « Connected ». Un échec vient presque toujours d'un prérequis manquant ou d'une authentification non faite. Les serveurs `uvx …` / `npx …` se téléchargent au premier lancement, donc le premier démarrage peut être lent.

## Étape 4 : serveurs avec clé API (facultatif)

1. **Atlas Cloud** : crée une clé sur atlascloud.ai (Kling, Seedance, Veo, Suno, etc.).
2. **ElevenLabs** : crée une clé sur elevenlabs.io (voix, crédits consommés).
3. **GitHub** : crée un token fine-grained limité aux dépôts utiles.

```bash
 ATLASCLOUD_API_KEY=xxx ELEVENLABS_API_KEY=xxx GITHUB_PAT=xxx bash install-api-keys.sh
```

- Les variables absentes sont ignorées.
- L'espace en début de ligne évite que les clés aillent dans l'historique du shell (bash avec `HISTCONTROL=ignorespace`, zsh avec `setopt HIST_IGNORE_SPACE`).
- Les clés sont stockées en clair dans `~/.claude.json` : ne partage pas ce fichier.
- Pour changer une clé : `claude mcp remove --scope user NOM`, puis relance le script.

## Étape 5 : connecteurs manuels (claude.ai / Claude Desktop)

Réglages > Connecteurs (ou « + » dans la conversation > Connecteurs) :

- **Adobe for creativity** : installer, puis se connecter à Adobe (le mode invité marche, avec des limites).
- **Canva** : Connecter.
- **DHS (Demographic and Health Surveys)** : connecteur natif, indicateurs agrégés en lecture seule.
- **PubMed** et **ICD-10 Codes** : connecteurs natifs à chercher dans le répertoire.
- **Zapier** : coller le prompt d'onboarding de docs.zapier.com/mcp/get-started/connect/claude.

## Étape 6 : réglages à faire à la main

| Outil | À faire |
|-------|---------|
| Blender | `uvx mcp-for-blender install-addon`, puis dans Blender : Édition > Préférences > Modules complémentaires, activer « Interface: MCP for Blender ». Dans la barre latérale (touche N), cliquer **Start MCP Server**. |
| CatCut | Installer Kdenlive, puis copier la config affichée par `catcut config show-mcp`. |
| HyperFrames | Le script le branche avec `uvx timeverse-hyperframes-mcp`, une commande vérifiée dans le paquet. S'il demande son CLI, installe-le (voir sa doc), puis teste avec `/mcp`. |
| Recreator | Installé par `pip` mais non branché. La commande de lancement est `recreator-mcp` : `claude mcp add --scope user recreator -- recreator-mcp` |
| GitMCP (lecture seule) | `claude mcp add --scope user --transport http gitmcp https://gitmcp.io/OWNER/REPO`, en remplaçant `OWNER/REPO` par un vrai dépôt. |

## Étape 7 : CLAUDE.md

Copie `CLAUDE.md` à la racine du projet, ou dans `~/.claude/CLAUDE.md` pour tous les projets. Il contient tes 10 références de sites 3D et animés. Claude Code lit ce fichier mais n'ouvre pas les sites tout seul.

## Étape 8 : Beat-Cut Studio (manuel)

[beat-cut.com/studio](https://beat-cut.com/studio) : studio web (BPM auto, coupes sur le beat, export 9:16).

- Compte requis, 7 jours d'essai Pro, aucun prix affiché.
- Aucune API ni MCP mentionnée, rien sur les droits musicaux.

Les alternatives gratuites installées par le script sont Kinocut et le skill `beat-sync-video-editing`.

## Chaîne audiovisuelle

Brief (Claude) > plans IA et musique (Atlas Cloud) > voix (ElevenLabs) > motion (Remotion, HyperFrames) > montage (Kinocut, CatCut, Premiere via Adobe) > 3D (Blender) > visuels (Canva, Figma, Adobe) > automatisation (Zapier).

## Exclus volontairement

- **SiteSkite** : RCE critique (CVE-2026-96349, CVSS 10) jusqu'à la 2.1.8, corrigée en 2.2.0.
- **Google Flow** : aucun MCP officiel. Le serveur communautaire pilote l'interface via Chrome (fragile).
- **dsh-mcp-center**, **keyless-mcp (sineframe)** : introuvables.

## Sécurité

Un serveur MCP s'exécute avec tes droits. Installe-les un par un, lis les permissions demandées, et garde tes clés hors des fichiers partagés.

## Retirer un serveur

```bash
claude mcp remove --scope user NOM
```
