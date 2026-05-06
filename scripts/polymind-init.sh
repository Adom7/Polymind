#!/usr/bin/env bash
# polymind-init.sh — pose le bon adapter pour le LLM choisi
# Usage : ./polymind-init.sh <llm> [target_dir] [--global]
#   <llm>       claude | codex | gemini | cursor | windsurf | aider
#   target_dir  (optionnel) racine où poser l'adapter ; défaut = pwd
#   --global    pose l'adapter dans le home du LLM (~/.claude, ~/.codex, ~/.gemini)
#
# Le script substitue ${POLYMIND_ROOT} par le path absolu de ce kit dans le fichier posé.

set -euo pipefail

# --- args ---
if [ $# -lt 1 ]; then
  echo "Usage: $0 <claude|codex|gemini|cursor|windsurf|aider> [target_dir] [--global]" >&2
  exit 2
fi

LLM="$1"
shift || true

TARGET=""
GLOBAL=0
while [ $# -gt 0 ]; do
  case "$1" in
    --global) GLOBAL=1 ;;
    *) TARGET="$1" ;;
  esac
  shift
done

# --- résolution du repo Polymind (parent de scripts/) ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
POLYMIND_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# --- défaut TARGET ---
if [ -z "${TARGET}" ]; then
  TARGET="$(pwd)"
fi

# --- résolution destination par LLM ---
case "${LLM}" in
  claude)
    SRC="${POLYMIND_ROOT}/adapters/claude/CLAUDE.md"
    if [ "${GLOBAL}" = "1" ]; then
      DEST="${HOME}/.claude/CLAUDE.md"
    else
      DEST="${TARGET}/CLAUDE.md"
    fi
    ;;
  codex)
    SRC="${POLYMIND_ROOT}/adapters/codex/AGENTS.md"
    if [ "${GLOBAL}" = "1" ]; then
      DEST="${CODEX_HOME:-${HOME}/.codex}/AGENTS.md"
    else
      DEST="${TARGET}/AGENTS.md"
    fi
    ;;
  gemini)
    SRC="${POLYMIND_ROOT}/adapters/gemini/GEMINI.md"
    if [ "${GLOBAL}" = "1" ]; then
      DEST="${HOME}/.gemini/GEMINI.md"
    else
      DEST="${TARGET}/GEMINI.md"
    fi
    ;;
  cursor)
    SRC="${POLYMIND_ROOT}/adapters/cursor/.cursor/rules/polymind.mdc"
    DEST="${TARGET}/.cursor/rules/polymind.mdc"
    ;;
  windsurf)
    SRC="${POLYMIND_ROOT}/adapters/windsurf/.windsurf/rules/polymind.md"
    DEST="${TARGET}/.windsurf/rules/polymind.md"
    ;;
  aider)
    SRC_CONV="${POLYMIND_ROOT}/adapters/aider/CONVENTIONS.md"
    SRC_CONF="${POLYMIND_ROOT}/adapters/aider/.aider.conf.yml"
    DEST_CONV="${TARGET}/CONVENTIONS.md"
    DEST_CONF="${TARGET}/.aider.conf.yml"
    ;;
  *)
    echo "Erreur : LLM inconnu '${LLM}'. Choix : claude|codex|gemini|cursor|windsurf|aider" >&2
    exit 2
    ;;
esac

# --- substitution + écriture ---
substitute_and_write() {
  local src="$1"
  local dest="$2"
  if [ ! -f "${src}" ]; then
    echo "Erreur : adapter source introuvable : ${src}" >&2
    exit 3
  fi
  mkdir -p "$(dirname "${dest}")"
  # remplacer ${POLYMIND_ROOT} par le path résolu
  sed "s|\${POLYMIND_ROOT}|${POLYMIND_ROOT}|g" "${src}" > "${dest}"
  echo "✓ posé : ${dest}"
}

if [ "${LLM}" = "aider" ]; then
  substitute_and_write "${SRC_CONV}" "${DEST_CONV}"
  # .aider.conf.yml ne contient pas de ${POLYMIND_ROOT}, copie directe
  cp "${SRC_CONF}" "${DEST_CONF}"
  echo "✓ posé : ${DEST_CONF}"
else
  substitute_and_write "${SRC}" "${DEST}"
fi

# --- résumé ---
cat <<EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PolyMind initialisé pour : ${LLM}
Repo Polymind : ${POLYMIND_ROOT}
EOF

if [ "${LLM}" = "aider" ]; then
  echo "Lance Aider depuis : ${TARGET}"
  echo "Aider chargera CONVENTIONS.md automatiquement (via .aider.conf.yml)"
else
  echo "Adapter posé à : ${DEST}"
fi

cat <<EOF

Étapes suivantes :
  1) cp FACTS/FACTS_user.md.template FACTS/FACTS_user.md
  2) Éditer FACTS/FACTS_user.md
  3) bash scripts/polymind-validate.sh "${POLYMIND_ROOT}"
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
