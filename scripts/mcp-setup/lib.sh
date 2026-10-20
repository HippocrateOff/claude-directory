# Fonctions communes (chargé par les autres scripts) — ne pas lancer seul.

have() { command -v "$1" >/dev/null 2>&1; }
if ! have pip && have pip3; then pip() { pip3 "$@"; }; fi

OK=(); SKIP=(); FAIL=()

need_claude() {
  have claude || { echo "ERREUR : 'claude' (Claude Code) est introuvable. Installe-le d'abord."; exit 1; }
}

# missing CMD... : affiche le premier outil absent et renvoie 0 s'il y en a un
missing() { for r in "$@"; do have "$r" || { echo "$r"; return 0; }; done; return 1; }

skip() { echo "[SKIP] $1 : $2"; SKIP+=("$1 ($2)"); }
ok()   { echo "[ OK ] $1"; OK+=("$1"); }

# mcp_step NOM [PREREQUIS...] -- ARGUMENTS de "claude mcp add"
mcp_step() {
  local name="$1"; shift; local reqs=()
  while [ "$1" != "--" ]; do reqs+=("$1"); shift; done; shift
  local m
  if m=$(missing "${reqs[@]}"); then skip "$name" "prérequis manquant : $m"; return; fi
  if claude mcp get "$name" >/dev/null 2>&1; then ok "$name (déjà enregistré)"; return; fi
  echo "[....] $name"
  if claude mcp add "$@"; then OK+=("$name"); else echo "[FAIL] $name"; FAIL+=("$name"); fi
}

# cmd_step NOM [PREREQUIS...] -- COMMANDE...
cmd_step() {
  local name="$1"; shift; local reqs=()
  while [ "$1" != "--" ]; do reqs+=("$1"); shift; done; shift
  local m
  if m=$(missing "${reqs[@]}"); then skip "$name" "prérequis manquant : $m"; return; fi
  echo "[....] $name"
  if "$@"; then OK+=("$name"); else echo "[FAIL] $name"; FAIL+=("$name"); fi
}

# has_plugin NOM@MARKETPLACE : vrai si le plugin Claude Code est déjà installé
has_plugin() { claude plugin list 2>/dev/null | grep -q "$1"; }

is_windows() { case "$(uname -s 2>/dev/null)" in MINGW*|MSYS*|CYGWIN*) return 0;; *) return 1;; esac; }

summary() {
  echo; echo "=== Résumé ==="
  echo "OK   : ${OK[*]:-}"
  echo "SKIP : ${SKIP[*]:-}"
  echo "FAIL : ${FAIL[*]:-}"
  echo; claude mcp list
}
