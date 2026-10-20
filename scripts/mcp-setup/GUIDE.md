# Guide : après `install-mcp.sh`

## 1. Vérifier

```bash
claude mcp list
```

Dans Claude Code, `/mcp` affiche l'état de chaque serveur. Un serveur `stdio` (`uvx …`, `npx …`) se télécharge à son premier lancement, donc le premier démarrage peut être lent.

## 2. Serveurs à compte (OAuth)

`vulk`, `Canva`, `figma` et `Zapier-MCP` sont enregistrés, mais ils restent inactifs tant que tu ne t'es pas connecté :

1. Lance `claude`, puis tape `/mcp`.
2. Choisis le serveur, puis **Authenticate**.
3. Le navigateur s'ouvre : connecte-toi et accepte.

Le jeton est conservé, et tu n'as à le refaire que s'il expire.

## 3. Cas particuliers

| Outil | Ce qu'il reste à faire |
|-------|------------------------|
| `kinocut` | Nécessite `ffmpeg`. Si `kino` est introuvable après `pip install`, ajoute `~/.local/bin` à ton `PATH`, puis relance le script. |
| `blender` | Blender doit être ouvert avec l'add-on MCP activé. Le serveur ne fait que piloter Blender. |
| `recreator-mcp` | Installé par `pip` mais **non branché**. Pour l'ajouter : `claude mcp add --scope user recreator -- recreator-mcp` |
| `catcut` | Nécessite **Kdenlive**. Le script affiche sa config MCP (`catcut config show-mcp`) : copie-la dans ta config Claude, ou ajoute-la avec `claude mcp add`. |
| `beat-sync-video-editing` | C'est un skill, pas un serveur MCP. Il utilise `ffmpeg`. |

## 4. Clés API

Aucun serveur de ce script n'exige de clé. Si un serveur en demande une plus tard, passe-la avec `-e` :

```bash
claude mcp remove --scope user NOM
claude mcp add --scope user -e MA_CLE=xxx NOM -- commande …
```

## 5. Retirer un serveur

```bash
claude mcp remove --scope user NOM
```
