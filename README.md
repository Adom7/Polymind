# PolyMind

> **Système de mémoire structurée pour LLM.** Format Markdown pur, déterministe, auditable, portable.

PolyMind garantit que **le même LLM, sur la même question, à travers plusieurs sessions, applique le même chemin de lecture et d'écriture** — éliminant la variance comportementale qui pourrit aujourd'hui les vaults personnels assistés par IA.

Ce dépôt est le **starter kit blank** : tu le clones (ou le forkes), tu remplis tes propres faits, et n'importe quel LLM compatible (Claude Code, Codex, etc.) sait où lire et où écrire.

---

## Pourquoi

Quatre problèmes que PolyMind résout :

1. **Info perdue** — tu donnes un fait au LLM, il le "stocke" quelque part, et la session suivante l'info est introuvable.
2. **Doublons sémantiques** — deux sessions différentes créent `entreprise.md` et `auto_entreprise.md` pour le même domaine.
3. **Surcharge contextuelle** — tout chargé au session-start, 50k tokens dont 80% jamais lus.
4. **Variance comportementale** — même question → 2 instances → 2 réponses divergentes. Pas reproductible.

La cause racine commune : **pas de protocole déterministe de lecture/écriture**. Le LLM décide librement → la décision varie.

---

## Architecture en 30 secondes

```
polymind/
├── README.md              ← tu es ici
├── TAXONOMY.md            ← les 6+1 racines + 8 règles d'extension
├── PROTOCOL_read.md       ← algorithme de lecture déterministe
├── PROTOCOL_write.md      ← algorithme d'écriture déterministe + arbre de décision
├── ROUTING.md             ← table déclarative trigger → fichier
├── INDEX.md               ← équivalent MEMORY.md, source de vérité
├── FACTS/                 ← always-load (hardware, identité, OS, runtime)
├── USR/                   ← personne physique
├── ENT/                   ← entités (société, AE, asso, missions)
├── PRJ/                   ← projets actifs / archivés
├── KNW/                   ← connaissance externe (docs, outils, refs)
├── OPS/                   ← règles opérationnelles, protocoles, comportement
└── LOG/                   ← journal (sessions, weekly, snapshots)
```

Les 6+1 racines sont **sémantiquement disjointes**. Chaque fait a **une racine canonique** déterminée par un arbre de décision (cf. `PROTOCOL_write.md`).

---

## Démarrer en 5 minutes

### Option A — Fork (recommandé si tu veux ton repo perso, lié à l'upstream)
```bash
# Sur GitHub : clique "Fork" en haut à droite du repo.
git clone git@github.com:<ton-user>/polymind.git
cd polymind
```

### Option B — Use this template (repo neuf, indépendant)
```bash
# Sur GitHub : clique "Use this template" → Create a new repository.
# Puis :
git clone git@github.com:<ton-user>/<ton-repo>.git
cd <ton-repo>
```

### Option C — Clone direct (si tu veux juste expérimenter localement)
```bash
git clone git@github.com:adom7/polymind.git
cd polymind
rm -rf .git && git init
```

### Ensuite
1. Lis `TAXONOMY.md` (10 min) — c'est le cœur conceptuel.
2. Ouvre `FACTS/FACTS_user.md` et remplis tes faits durs (hardware, OS, identité).
3. Adapte `ROUTING.md` à ton vocabulaire (ajoute / supprime des lignes).
4. Pose l'adapter pour ton LLM (cf. section suivante).

---

## Multi-LLM — installation en une commande

PolyMind se branche sur 6 LLMs majeurs via des adapters dédiés, chacun respectant la convention auto-load native du LLM (sources doc officielles citées dans `LLM_ADAPTERS.md`) :

| LLM | Auto-load | Adapter |
|---|---|---|
| Claude Code (Anthropic) | `CLAUDE.md` | [`adapters/claude/`](adapters/claude/CLAUDE.md) |
| Codex CLI (OpenAI) | `AGENTS.md` | [`adapters/codex/`](adapters/codex/AGENTS.md) |
| Gemini CLI (Google) | `GEMINI.md` | [`adapters/gemini/`](adapters/gemini/GEMINI.md) |
| Cursor | `.cursor/rules/*.mdc` | [`adapters/cursor/`](adapters/cursor/.cursor/rules/polymind.mdc) |
| Windsurf (Codeium) | `.windsurf/rules/*.md` | [`adapters/windsurf/`](adapters/windsurf/.windsurf/rules/polymind.md) |
| Aider | `.aider.conf.yml` (manuel) | [`adapters/aider/`](adapters/aider/CONVENTIONS.md) |

```bash
# Pose l'adapter au bon endroit avec ${POLYMIND_ROOT} substitué automatiquement
bash scripts/polymind-init.sh claude        # ou: codex | gemini | cursor | windsurf | aider
# Avec --global : pose dans ~/.claude/, ~/.codex/, ~/.gemini/ (selon LLM)

# Vérifie la cohérence du repo (frontmatter, INDEX, adapters, .gitignore…)
bash scripts/polymind-validate.sh .
# Score: 100/100 attendu

# Teste le comportement avec 5 prompts pré-écrits
cat scripts/test-prompts.md
```

Détails par LLM (paths exacts, frontmatters, particularités) : [`LLM_ADAPTERS.md`](LLM_ADAPTERS.md).
Mémoire locale vs Git, secrets, sync multi-machines : [`STORAGE.md`](STORAGE.md).

---

## Principes durs

1. **Format MD pur.** Pas de DSL. Lisible humain, parsable LLM, portable.
2. **Aucune décision d'écriture libre.** Le LLM suit le routing ou demande.
3. **Toute extension de taxonomie = décision user.** Jamais auto.
4. **Archivage, jamais suppression silencieuse.**
5. **Slug ASCII pur, snake_case.** Pas d'accents, pas d'espaces, pas de tirets.

Détails complets dans `TAXONOMY.md` §3 (les 8 règles).

---

## État du projet

- **v1 design** : TAXONOMY, ROUTING, PROTOCOL_read, PROTOCOL_write, INDEX, FACTS template (Sprint 1 livré).
- **v1 multi-LLM** : adapters Claude / Codex / Gemini / Cursor / Windsurf / Aider + scripts `polymind-init.sh` et `polymind-validate.sh` + `STORAGE.md` + `LLM_ADAPTERS.md` (Sprint 2 livré 2026-05-06).
- À venir : GitHub Action validator sur PR, loader cross-LLM générique, intégration Graphify optionnelle, Continue.dev, Zed AI.

Projet pensé en MAs (milestones) avec saves fréquents.

---

## Licence

MIT. Cf. `LICENSE`.
