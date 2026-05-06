#!/usr/bin/env bash
# polymind-validate.sh — valide la cohérence d'un kit PolyMind et retourne un score 0-100
# Usage : ./polymind-validate.sh [path_kit]   (défaut = parent de ce script)
#
# Sortie : résumé humain + JSON {score, issues[]} sur stderr si --json

set -uo pipefail

KIT="${1:-}"
if [ -z "${KIT}" ]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  KIT="$(cd "${SCRIPT_DIR}/.." && pwd)"
fi

if [ ! -d "${KIT}" ]; then
  echo "Erreur : kit introuvable : ${KIT}" >&2
  exit 2
fi

KIT="$(cd "${KIT}" && pwd)"
ISSUES=()
SCORE=100

add_issue() {
  local penalty="$1"
  local msg="$2"
  ISSUES+=("[-${penalty}] ${msg}")
  SCORE=$(( SCORE - penalty ))
}

# --- 1. Fichiers cœur (-15 par fichier manquant, max -60) ---
CORE_FILES=("README.md" "TAXONOMY.md" "ROUTING.md" "PROTOCOL_read.md" "PROTOCOL_write.md" "INDEX.md" "STORAGE.md" "LLM_ADAPTERS.md" ".gitignore")
CORE_MISSING=0
for f in "${CORE_FILES[@]}"; do
  if [ ! -f "${KIT}/${f}" ]; then
    add_issue 7 "Fichier cœur manquant : ${f}"
    CORE_MISSING=$((CORE_MISSING+1))
  fi
done

# --- 2. Racines (-3 par racine manquante) ---
for r in USR ENT PRJ KNW OPS LOG FACTS; do
  if [ ! -d "${KIT}/${r}" ]; then
    add_issue 3 "Racine manquante : ${r}/"
  fi
done

# --- 3. Template FACTS_user (-5) ---
if [ ! -f "${KIT}/FACTS/FACTS_user.md.template" ] && [ ! -f "${KIT}/FACTS/FACTS_user.md" ]; then
  add_issue 5 "Aucun template ou fichier FACTS_user.md"
fi

# --- 4. Adapters (-4 par adapter manquant) ---
declare -a ADAPTERS=(
  "adapters/claude/CLAUDE.md"
  "adapters/codex/AGENTS.md"
  "adapters/gemini/GEMINI.md"
  "adapters/cursor/.cursor/rules/polymind.mdc"
  "adapters/windsurf/.windsurf/rules/polymind.md"
  "adapters/aider/CONVENTIONS.md"
  "adapters/aider/.aider.conf.yml"
)
for a in "${ADAPTERS[@]}"; do
  if [ ! -f "${KIT}/${a}" ]; then
    add_issue 4 "Adapter manquant : ${a}"
  fi
done

# --- 5. Scripts (-5 par script manquant) ---
for s in "scripts/polymind-init.sh" "scripts/polymind-validate.sh"; do
  if [ ! -f "${KIT}/${s}" ]; then
    add_issue 5 "Script manquant : ${s}"
  elif [ ! -x "${KIT}/${s}" ]; then
    add_issue 2 "Script non exécutable : ${s} (chmod +x)"
  fi
done

# test-prompts existe (-3)
if [ ! -f "${KIT}/scripts/test-prompts.md" ]; then
  add_issue 3 "scripts/test-prompts.md manquant"
fi

# --- 6. Frontmatter sur fichiers cœur MD (-2 par champ manquant) ---
check_frontmatter() {
  local f="$1"
  if [ ! -f "${f}" ]; then return; fi
  local first_line
  first_line=$(head -n 1 "${f}" || echo "")
  if [ "${first_line}" != "---" ]; then
    add_issue 3 "Frontmatter absent : ${f#${KIT}/}"
    return
  fi
  for field in type root slug created updated status; do
    if ! awk '/^---$/{c++; next} c==1' "${f}" | grep -q "^${field}:"; then
      add_issue 2 "Frontmatter incomplet (${field}) : ${f#${KIT}/}"
    fi
  done
}

for f in "${KIT}/TAXONOMY.md" "${KIT}/ROUTING.md" "${KIT}/PROTOCOL_read.md" "${KIT}/PROTOCOL_write.md" "${KIT}/STORAGE.md" "${KIT}/LLM_ADAPTERS.md" "${KIT}/INDEX.md"; do
  check_frontmatter "${f}"
done

# --- 7. Cursor MDC : alwaysApply requis (-5) ---
if [ -f "${KIT}/adapters/cursor/.cursor/rules/polymind.mdc" ]; then
  if ! grep -q "^alwaysApply: true" "${KIT}/adapters/cursor/.cursor/rules/polymind.mdc"; then
    add_issue 5 "Cursor MDC : alwaysApply: true manquant dans le frontmatter"
  fi
fi

# --- 8. Windsurf : trigger always_on requis (-5) ---
if [ -f "${KIT}/adapters/windsurf/.windsurf/rules/polymind.md" ]; then
  if ! grep -q "^trigger: always_on" "${KIT}/adapters/windsurf/.windsurf/rules/polymind.md"; then
    add_issue 5 "Windsurf : trigger: always_on manquant dans le frontmatter"
  fi
fi

# --- 9. Substitution placeholder ${POLYMIND_ROOT} dans adapters (info, pas pénalité) ---
# (chaque adapter doit le contenir avant init)
for a in "adapters/claude/CLAUDE.md" "adapters/codex/AGENTS.md" "adapters/gemini/GEMINI.md" "adapters/cursor/.cursor/rules/polymind.mdc" "adapters/windsurf/.windsurf/rules/polymind.md" "adapters/aider/CONVENTIONS.md"; do
  if [ -f "${KIT}/${a}" ]; then
    if ! grep -q '${POLYMIND_ROOT}' "${KIT}/${a}"; then
      add_issue 3 "Adapter sans placeholder \${POLYMIND_ROOT} : ${a}"
    fi
  fi
done

# --- 10. INDEX cohérent : chaque ligne `- [` pointe vers fichier existant (-2 chaque) ---
if [ -f "${KIT}/INDEX.md" ]; then
  while IFS= read -r line; do
    # extraire le path entre parenthèses dans une ligne markdown link `- [name](path) — desc`
    path=$(echo "${line}" | sed -nE 's/^- \[[^]]+\]\(([^)]+)\).*/\1/p')
    if [ -n "${path}" ]; then
      # ignorer URLs et anchors
      case "${path}" in
        http*|"#"*) continue ;;
      esac
      if [ ! -f "${KIT}/${path}" ]; then
        add_issue 2 "INDEX.md référence un fichier inexistant : ${path}"
      fi
    fi
  done < "${KIT}/INDEX.md"
fi

# --- 10b. Git ready (warning, pas pénalité — kit upstream peut être hors repo) ---
GIT_WARN=""
if ! command -v git >/dev/null 2>&1; then
  GIT_WARN="git non installé — installe-le avant d'utiliser PolyMind multi-machines"
elif ! git -C "${KIT}" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  GIT_WARN="kit hors repo Git — fork/clone le kit dans ton propre repo (cf. STORAGE.md)"
elif ! git config --global --get user.email >/dev/null 2>&1; then
  GIT_WARN="git user.email non configuré (git config --global user.email \"…\")"
fi

# --- 11. Borne plancher score ---
if [ ${SCORE} -lt 0 ]; then SCORE=0; fi

# --- 12. Output ---
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "PolyMind validation — kit : ${KIT}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ ${#ISSUES[@]} -eq 0 ]; then
  echo "Aucune issue détectée."
else
  echo "Issues (${#ISSUES[@]}) :"
  for i in "${ISSUES[@]}"; do
    echo "  • ${i}"
  done
fi
echo ""
if [ -n "${GIT_WARN}" ]; then
  echo "⚠ Git : ${GIT_WARN}"
  echo ""
fi
echo "Score : ${SCORE}/100"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# JSON sur stderr (utile pour automatisation)
{
  printf '{"score":%d,"issues":[' "${SCORE}"
  first=1
  if [ ${#ISSUES[@]} -gt 0 ]; then
    for i in "${ISSUES[@]}"; do
      if [ ${first} -eq 1 ]; then first=0; else printf ','; fi
      # échapper guillemets minimal
      esc=$(printf '%s' "${i}" | sed 's/\\/\\\\/g; s/"/\\"/g')
      printf '"%s"' "${esc}"
    done
  fi
  printf ']}\n'
} >&2

# Code de sortie : 0 si score == 100, 1 sinon
if [ ${SCORE} -eq 100 ]; then
  exit 0
else
  exit 1
fi
