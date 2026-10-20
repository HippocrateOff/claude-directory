# MCP setup

One-shot script that registers research and video-editing MCP servers for Claude Code at **user scope**, which makes them available in every project on your machine.

```bash
./scripts/mcp-setup/setup.sh
```

Requires `claude`, `uvx` (from [uv](https://docs.astral.sh/uv/)), `npx` (Node.js), and `pip`. The script can be run again safely: it skips any server that is already registered.

| Name | Kind | What it does |
|------|------|--------------|
| `parallel-search` | HTTP | Web search via Parallel |
| `idc` | HTTP | NCI Imaging Data Commons (cancer imaging datasets) |
| `keyless-research` | stdio (`uvx keyless-research-mcp`) | Research sources with no API key needed |
| `clinicaltrials` | stdio (`npx clinicaltrialsgov-mcp-server`) | ClinicalTrials.gov search |
| `kinocut` | stdio (`kino --mcp`, from `pip install kinocut`) | Video editing |
| `blender` | stdio (`uvx mcp-for-blender`) | Blender control (needs Blender running with its add-on) |
| `remotion` | stdio (`npx @remotion/mcp`) | Remotion docs and help with programmatic video |

It also installs the `beat-sync-video-editing` skill from [ecliptic-ai/skills](https://github.com/ecliptic-ai/skills). This skill is a free, FFmpeg-based alternative to Beat-Cut that cuts video to the beats of a track.

To remove a server: `claude mcp remove --scope user <name>`.
