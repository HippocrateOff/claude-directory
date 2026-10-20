# MCP setup

A kit that registers research, video-editing and design MCP servers, plugins and skills for Claude Code at **user scope**, which makes them available in every project on your machine.

| Script | What it installs |
|--------|------------------|
| `install-mcp.sh` | The core: verified servers that need no API key, the HyperFrames plugin, the beat-sync skill, and the OAuth servers |
| `install-optional.sh` | Servers with heavy prerequisites: R, QGIS, Figma Desktop, Windows/Kdenlive, and full Blender with `BLENDER_FULL=1` |
| `install-api-keys.sh` | Servers that need a key: Atlas Cloud, ElevenLabs, GitHub. Only the keys you provide are used |
| `lib.sh` | Shared helper functions, loaded by the scripts above. Don't run it on its own |

```bash
bash scripts/mcp-setup/install-mcp.sh
bash scripts/mcp-setup/install-optional.sh
 ATLASCLOUD_API_KEY=xxx ELEVENLABS_API_KEY=xxx GITHUB_PAT=xxx bash scripts/mcp-setup/install-api-keys.sh
```

- Each step checks that its tools are installed. If one is missing, the step is skipped and listed under `SKIP` in the summary instead of breaking the run.
- You can run any script again safely: whatever is already installed counts as OK.
- [GUIDE.md](./GUIDE.md), in French, is the step-by-step guide: prerequisites, logging into OAuth servers with `/mcp`, optional servers, API keys, manual connectors, and the audio/video pipeline.
- [CLAUDE.md](./CLAUDE.md) lists references for 3D and animated websites, plus rules for programmatic video. Copy it to a project root or to `~/.claude/CLAUDE.md`.

Remotion is not included: Remotion deprecated its MCP server in favour of Agent Skills. In a Remotion project, run `npx remotion skills add`.
