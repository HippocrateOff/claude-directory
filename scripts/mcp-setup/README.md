# MCP setup

`install-mcp.sh` registers research, video-editing and design MCP servers for Claude Code at **user scope**, which makes them available in every project on your machine.

```bash
bash scripts/mcp-setup/install-mcp.sh
```

- Each step checks that its tools are installed (`uvx`, `npx`, `pip`, `uv`, `ffmpeg`, `kino`). If one is missing, the step is skipped and listed under `SKIP` in the summary instead of breaking the run.
- You can run the script again safely: a server that is already registered counts as OK.
- `install-api-keys.sh` adds the servers that need a key (Atlas Cloud, ElevenLabs, GitHub), using only the environment variables you set.
- [GUIDE.md](./GUIDE.md), in French, is the step-by-step guide: prerequisites, logging into OAuth servers with `/mcp`, API keys, manual connectors, and the audio/video pipeline.
- [CLAUDE.md](./CLAUDE.md) lists references for 3D and animated websites. Copy it to a project root or to `~/.claude/CLAUDE.md`.

| Name | Group | What it does |
|------|-------|--------------|
| `parallel-search` | free | Web search via Parallel |
| `idc` | free | NCI Imaging Data Commons (cancer imaging datasets) |
| `keyless-research` | free | Research sources with no API key needed |
| `clinicaltrials` | free | ClinicalTrials.gov search |
| `kinocut` | video | Video editing (`pip install kinocut`, needs ffmpeg) |
| `blender` | video | Blender control (Blender must be running with its add-on) |
| `remotion` | video | Remotion docs and help with programmatic video |
| `hyperframes` | video | `uvx timeverse-hyperframes-mcp` |
| `recreator-mcp` | video | Installed with pip but not registered (see GUIDE.md) |
| `beat-sync-video-editing` | video | Skill: FFmpeg-based editing synced to beats, a free alternative to Beat-Cut |
| `catcut` | video | Installed with `uv tool`; prints its MCP config (needs Kdenlive) |
| `vulk`, `Canva`, `figma`, `Zapier-MCP` | OAuth | Need you to log in with `/mcp` |
| `atlascloud`, `elevenlabs`, `github` | API key | Added by `install-api-keys.sh` |
