---
type: cahier
root: META
slug: llm_adapters
created: 2026-05-06
updated: 2026-05-06
status: active
links: [taxonomy, storage]
---

# LLM_ADAPTERS — installer PolyMind sur n'importe quel LLM

> Chaque LLM a son propre mécanisme d'auto-load et son propre format. PolyMind fournit un adapter par LLM dans `adapters/`. Le script `scripts/polymind-init.sh <llm>` pose le bon fichier au bon endroit avec le path résolu.

## Tableau récapitulatif

| LLM | Auto-load global | Auto-load projet | Format | Adapter PolyMind |
|---|---|---|---|---|
| **Claude Code** | `~/.claude/CLAUDE.md` | `./CLAUDE.md` ou `./.claude/CLAUDE.md` (+ `CLAUDE.local.md`) | MD libre, imports `@path` (5 hops) | `adapters/claude/CLAUDE.md` |
| **Codex CLI** | `~/.codex/AGENTS.md` | `./AGENTS.md` (walk depuis git root) | MD libre | `adapters/codex/AGENTS.md` |
| **Gemini CLI** | `~/.gemini/GEMINI.md` | `./GEMINI.md` (hiérarchique) | MD libre, imports `@file` | `adapters/gemini/GEMINI.md` |
| **Cursor** | Settings UI | `.cursor/rules/*.mdc` | MDC : YAML front (`alwaysApply`/`globs`/`description`) + corps | `adapters/cursor/.cursor/rules/polymind.mdc` |
| **Windsurf** | `~/.codeium/windsurf/memories/global_rules.md` | `.windsurf/rules/*.md` | MD avec front `trigger:` (`always_on`/`glob`/`model_decision`/`manual`) | `adapters/windsurf/.windsurf/rules/polymind.md` |
| **Aider** | aucun | aucun (manuel) | MD libre | `adapters/aider/CONVENTIONS.md` + `.aider.conf.yml` |

## Choix global vs projet

| Cas | Recommandation |
|---|---|
| Tu utilises PolyMind sur 1 seul "vrai" projet | Adapter dans **le projet** (versionné si non sensible) |
| Tu utilises PolyMind partout (mémoire perso transversale) | Adapter en **global** (`~/.claude/`, `~/.codex/`, `~/.gemini/`) |
| Tu travailles à plusieurs sur un repo | Adapter dans **le projet** (les co-équipiers en bénéficient via git pull) |

`polymind-init.sh` choisit "projet" par défaut. Pour global : `polymind-init.sh claude --global`.

## Différences de comportement à connaître

### Claude Code
- ✅ Imports `@path` natifs (5 hops) → l'adapter peut **pointer** vers `${POLYMIND_ROOT}/TAXONOMY.md` etc. sans dupliquer.
- ✅ `.local.md` reconnu nativement, gitignored.
- ⚠️ `~/.claude/projects/<slug>/memory/MEMORY.md` = auto-memory natif. Risque de doublon avec PolyMind. L'adapter dit explicitement au LLM d'**ignorer** cette couche au profit de PolyMind.

### OpenAI Codex
- ⚠️ **Pas d'imports** natifs → l'adapter est inline (contient les règles), il pointe vers le repo PolyMind par mention textuelle.
- ✅ Walk automatique depuis git root → poser `AGENTS.md` à la racine du repo PolyMind suffit pour les sessions lancées depuis là.
- ✅ Override : `AGENTS.override.md` permet d'écraser localement.

### Gemini CLI
- ✅ Imports `@file.md` natifs → comme Claude.
- ✅ Commandes `/memory show / reload / add` pour debugger l'état.
- ⚠️ Hiérarchique sous-dirs : un `GEMINI.md` dans un sous-dossier override le parent. Le poser à la racine du projet.

### Cursor
- ⚠️ Format **MDC** obligatoire (`.mdc`, pas `.md`).
- ⚠️ Frontmatter requis : `alwaysApply: true` pour l'équivalent always-load.
- ✅ Path versionné : `.cursor/rules/polymind.mdc` se commit avec le projet.

### Windsurf
- ⚠️ Format `.md` avec frontmatter `trigger: always_on`.
- ✅ Path : `.windsurf/rules/polymind.md` (versionné dans le projet).
- ⚠️ Le global rules a un cap de **6000 caractères** → on évite, on met l'adapter dans le projet.

### Aider
- ⚠️ **Aucun auto-load** → l'utilisateur doit lancer `aider --read CONVENTIONS.md` ou avoir un `.aider.conf.yml` :
  ```yaml
  read:
    - CONVENTIONS.md
  ```
- L'adapter `polymind-init.sh aider` pose les deux fichiers ; l'utilisateur lance Aider normalement après.

## Substitution de `${POLYMIND_ROOT}`

Tous les adapters contiennent le placeholder `${POLYMIND_ROOT}` pour pointer vers le repo PolyMind. `polymind-init.sh` le remplace par le path absolu résolu (par défaut, le dossier où `polymind-init.sh` est exécuté).

Exemple : si tu as cloné dans `~/polymind/`, après `polymind-init.sh claude`, le fichier `CLAUDE.md` posé contient `~/polymind/TAXONOMY.md`.

## Sources doc officielles

- Claude Code memory : <https://code.claude.com/docs/en/memory>
- OpenAI Codex AGENTS.md : <https://developers.openai.com/codex/guides/agents-md>
- Gemini CLI GEMINI.md : <https://google-gemini.github.io/gemini-cli/docs/cli/gemini-md.html>
- Cursor rules : <https://cursor.com/docs/context/rules>
- Windsurf memories : <https://docs.windsurf.com/windsurf/cascade/memories>
- Aider conventions : <https://aider.chat/docs/usage/conventions.html>

## Vérifier que l'adapter est bien chargé

Après `polymind-init.sh <llm>`, lance ton LLM et pose la question :

> *« Quelle est la racine PolyMind où on stocke un fait sur le statut TVA d'une entreprise ? »*

Réponse attendue (en s'appuyant sur ROUTING) : *« ENT, dans `ENT/ENT_business_status.md` selon `ROUTING.md`. »*

Si le LLM dit *« je ne sais pas »* ou invente une racine → l'adapter n'est pas chargé. Vérifier le path et relire la doc du LLM.

## Et un LLM non listé ?

Si ton LLM n'a pas de convention auto-load native :
1. Crée un fichier d'entrée minimal (Markdown).
2. Inline le cœur de ce qu'il faut (les 5 règles + le routing essentiel).
3. Ajoute en début de session : "lis le fichier X" ou utilise un script pré-prompt.
4. PR welcome pour ajouter un adapter officiel à PolyMind.
