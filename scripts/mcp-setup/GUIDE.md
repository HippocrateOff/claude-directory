# Guide pas à pas : connecteurs Claude + Claude Code

Fichiers du kit : `install-mcp.sh` (noyau), `install-optional.sh`, `install-api-keys.sh`, `lib.sh` (fonctions communes, ne pas lancer seul), `CLAUDE.md`, ce guide.
Rien n'est installé tant que tu n'as pas lancé ces étapes sur ta machine.

## Étape 0 : prérequis (une fois)

- Claude Code installé (`claude --version`).
- Node.js 22.16+ (`node -v`), Python 3.11+ (`python3 --version`) et `pip`.
- [uv](https://docs.astral.sh/uv/), qui fournit `uvx` (`uv --version`).
- ffmpeg (`ffmpeg -version`) : indispensable à Kinocut et au skill beat-sync.
- Facultatifs : Blender 3.0+ (MCP Blender), R ≥ 4.2 (clinical-trial-design), QGIS 3.28+ (qgis), Figma Desktop (figma-mcp-go), Windows + Kdenlive (CatCut).

## Étape 1 : serveurs sans clé (Claude Code)

Dans un terminal normal, depuis le dossier du kit :

```bash
bash install-mcp.sh
```

Le résumé final liste OK / SKIP / FAIL. Un SKIP veut dire qu'un prérequis manque : installe-le puis relance le script. Le relancer est sans danger, car un serveur déjà enregistré est compté OK.

Ce que le noyau installe :

- Serveurs MCP : parallel-search, idc, keyless-research, clinicaltrials, kinocut, blender, et les serveurs OAuth vulk, Canva, figma, Zapier-MCP.
- Plugin Claude Code **HyperFrames** (`hyperframes@hyperframes`, HeyGen).
- Skill `beat-sync-video-editing`, installé pour l'utilisateur (`~/.claude/skills`), sans question interactive.

Si `kino` reste introuvable après `pip install kinocut`, ajoute `~/.local/bin` à ton `PATH`.

**Remotion** n'est plus installé comme serveur MCP, car Remotion l'a déprécié. Dans un projet Remotion, lance `npx remotion skills add`, puis utilise `/remotion-docs`. Si une ancienne version du kit l'avait ajouté : `claude mcp remove --scope user remotion`.

## Étape 1 bis : serveurs optionnels

```bash
bash install-optional.sh                 # tout sauf Blender complet
BLENDER_FULL=1 bash install-optional.sh  # avec RFingAdam/mcp-blender (218 outils, AGPL-3.0)
```

Chaque bloc est sauté (SKIP) si son prérequis manque :

| Bloc | Prérequis | À faire ensuite |
|------|-----------|-----------------|
| clinical-trial-design (plugin) | R ≥ 4.2 et `R -e 'install.packages(c("gsDesign","gsDesign2","graphicalMCP","jsonlite","officer","rmarkdown"))'` | Rien |
| openresearch | uv | Rien. Sans compte ni clé : recherche web, lecture d'URL et de PDF, OpenAlex, Hacker News, Stack Overflow, dépôts, transcriptions YouTube |
| figma-mcp-go | Node, Figma Desktop | Figma Desktop > Plugins > Development > Import plugin from manifest (`manifest.json` du `plugin.zip` des releases GitHub) |
| qgis | QGIS 3.28+, uv, plugin QGIS | Voir « QGIS » ci-dessous |
| hyperframes (MCP timeverse) | uv, CLI `npx hyperframes` | Tester avec `/mcp` |
| recreator | pip | Rien. `recreator-mcp --help` vérifié : sans option, il parle stdio |
| blender-full | `BLENDER_FULL=1`, pip, git | N'active qu'**un** addon Blender à la fois : les deux utilisent le port 9876 |
| CatCut | Windows, uv (Python 3.11–3.12), Kdenlive | Copier la config affichée par `catcut config show-mcp` |

### QGIS

Le plugin QGIS est un prérequis manuel. Sans lui, le serveur MCP démarre mais ne peut pas piloter QGIS : le serveur parle au plugin par TCP sur `127.0.0.1:9876`.

1. Ouvre QGIS > Extensions > Installer/Gérer les extensions, cherche **QGIS MCP**, puis installe-le.
2. Démarre le serveur du plugin depuis son bouton dans la barre d'outils.
3. Vérifie que le port écoute : `lsof -i :9876` (macOS/Linux) ou `netstat -ano | findstr 9876` (Windows).
4. Dans Claude Code, `/mcp` doit afficher `qgis` connecté.

**Conflit de port :** QGIS MCP et les deux addons Blender (mcp-for-blender, mcp-blender) utilisent tous le port **9876**. Pour garder QGIS et Blender ouverts ensemble, change le port de QGIS dans le menu de son bouton (par exemple 9877). Ajoute ensuite le même port côté Claude Code :

```bash
claude mcp remove --scope user qgis
claude mcp add --scope user qgis -e QGIS_MCP_PORT=9877 -- uvx --from https://github.com/nkarasiak/qgis-mcp/archive/refs/heads/main.zip qgis-mcp-server
```

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
| Blender | `uvx mcp-for-blender install-addon`, puis dans Blender : Édition > Préférences > Modules complémentaires, activer « Interface: MCP for Blender ». Dans la barre latérale (touche N), cliquer **Start MCP Server**. Variante en une ligne : `curl -LsSf https://www.mcp-for-blender.com/install.sh \| sh` (Windows : `irm https://www.mcp-for-blender.com/install.ps1 \| iex`). Elle installe uv, configure tes clients MCP et active l'addon. Lis le script avant de le lancer : s'il ajoute lui aussi un serveur `blender`, tu peux l'avoir en double. |
| HyperFrames | Le plugin s'utilise via ses skills ; le CLI se lance avec `npx hyperframes init`, `preview` ou `render`. Si un fichier du plugin est un pointeur Git LFS, lance `git -C ~/.claude/plugins/marketplaces/hyperframes lfs pull`. Le rendu peut aussi passer par le MCP hébergé de HeyGen (`https://mcp.heygen.com/mcp/hyperframes`, crédits HeyGen, non testé ici). L'auto-hébergement (`ismailkattakath/hyperframes-selfhost`) n'est pas à considérer comme équivalent tant que le rendu local de tous les formats, MOV ProRes compris, n'a pas été testé. |
| GitMCP (lecture seule) | `claude mcp add --scope user --transport http gitmcp https://gitmcp.io/OWNER/REPO`, en remplaçant `OWNER/REPO` par un vrai dépôt. |

## Étape 7 : CLAUDE.md

Copie `CLAUDE.md` à la racine du projet, ou dans `~/.claude/CLAUDE.md` pour tous les projets. Il contient tes 10 références de sites 3D et animés, et les règles pour la vidéo programmatique (Remotion, HyperFrames, montage). Claude Code lit ce fichier mais n'ouvre pas les sites tout seul.

## Étape 8 : Beat-Cut Studio (manuel)

[beat-cut.com/studio](https://beat-cut.com/studio) : studio web (BPM auto, coupes sur le beat, export 9:16).

- Compte requis, 7 jours d'essai Pro, aucun prix affiché.
- Aucune API ni MCP mentionnée, rien sur les droits musicaux.

Les alternatives gratuites installées par le noyau sont Kinocut et le skill `beat-sync-video-editing`.

## Chaîne audiovisuelle

Brief (Claude) > plans IA et musique (Atlas Cloud) > voix (ElevenLabs) > motion (Remotion via skills, HyperFrames) > montage (Kinocut, CatCut, Premiere via Adobe) > 3D (Blender) > visuels (Canva, Figma, Adobe) > automatisation (Zapier).

## Exclus volontairement

- **SiteSkite** : RCE critique (CVE-2026-96349, CVSS 10) jusqu'à la 2.1.8, corrigée en 2.2.0.
- **Google Flow** : aucun MCP officiel. Le serveur communautaire pilote l'interface via Chrome (fragile).
- **keyless-mcp (sineframe)** : introuvable.
- **Hyperbits** : aucun paquet `hyperbits` sur npm (vérifié le 2026-10-21). À ajouter quand le nom exact du paquet sera connu.

## Sécurité

Un serveur MCP s'exécute avec tes droits. Installe-les un par un, lis les permissions demandées, et garde tes clés hors des fichiers partagés.

### DeepSeek Harness (dsh-mcp-center)

Hors kit, car c'est pour DeepSeek et non pour Claude Code. Le paquet npm `dsh-mcp-center` existe. Pour l'installer : `dsh plugin --profile web add dsh-mcp-center`, puis Settings > MCP Center pour ajouter les serveurs en HTTP ou stdio.

`~/.dsh/mcp-center.json` contient les tokens Bearer **en clair**. Traite-le comme un `.env` : ne le commite jamais, ne le partage pas, et garde-le hors des dossiers synchronisés.

## Retirer un serveur

```bash
claude mcp remove --scope user NOM
```
