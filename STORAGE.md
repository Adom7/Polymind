---
type: storage
root: META
slug: storage
created: 2026-05-06
updated: 2026-05-06
status: active
links: [taxonomy, llm_adapters]
---

# STORAGE — où vit la mémoire (local vs Git)

> PolyMind sépare strictement **contenu structuré** (Git) et **secrets / état machine** (local). Le fichier d'entrée du LLM est lui-même soit local au home, soit dans le projet — il **importe** le repo PolyMind par path résolu.

## Tu travailles sur TON repo, pas sur l'upstream

PolyMind est distribué comme **kit** (le dépôt upstream). Toi, tu as ton **propre repo Git** (fork ou repo perso) qui contient ta mémoire.

```
upstream/polymind             ← le kit officiel (tu ne push JAMAIS dessus)
        │ fork / clone
        ▼
<toi>/polymind                ← TON repo, privé recommandé, tu push ici
        │ clone local
        ▼
~/polymind                    ← copie de travail sur ta machine
```

**Workflow recommandé** :

1. Fork upstream **ou** crée un repo vide (privé recommandé) chez ton hébergeur Git.
2. `git clone <ton-repo>` localement.
3. `git remote add upstream <url-upstream>` pour suivre les évolutions de la taxonomie.
4. `git fetch upstream && git merge upstream/main` quand tu veux récupérer les améliorations.
5. Tes commits → `git push origin main` (sur **ton** repo).
6. Pour proposer une amélioration au kit : Pull Request depuis ton fork vers upstream.

Pré-requis Git :

```bash
git --version                                     # >= 2.20 conseillé
git config --global user.email "<toi>@…"
git config --global user.name  "<Ton Nom>"
git config --global init.defaultBranch main
```

Si tu n'as pas de remote Git : tu peux travailler en local-only (`git init` puis commits locaux), mais tu perds la sync multi-machines et le backup. Déconseillé sauf test rapide.

## Trois couches de persistance

```
┌──────────────────────────────────────────────────────────────────┐
│  1. Repo PolyMind (Git)                                          │
│     ~/polymind/    ← cloné ou copié                              │
│     ├── TAXONOMY.md, ROUTING.md, PROTOCOL_*.md                   │
│     ├── INDEX.md                                                  │
│     ├── FACTS/, USR/, ENT/, PRJ/, KNW/, OPS/, LOG/               │
│     └── adapters/, scripts/                                       │
│     → versionné, sync multi-machines via push/pull               │
│     → contenu non sensible uniquement                            │
└──────────────────────────────────────────────────────────────────┘
                              │
              import (@path / sed sur ${POLYMIND_ROOT})
                              │
┌──────────────────────────────────────────────────────────────────┐
│  2. Fichier d'entrée du LLM (local OU dans le projet)            │
│     ex: ~/.claude/CLAUDE.md (global, machine)                    │
│         ~/.codex/AGENTS.md (global, machine)                     │
│         ./CLAUDE.md (projet — peut être commit)                  │
│     → posé par scripts/polymind-init.sh                          │
│     → pointe vers le repo PolyMind                               │
└──────────────────────────────────────────────────────────────────┘
                              │
                              │
┌──────────────────────────────────────────────────────────────────┐
│  3. Couche locale (machine-specific, NEVER commit)               │
│     ex: KNW/KNW_api_keys.local.md                                │
│         USR/USR_secrets.local.md                                 │
│     → tout ce qui matche `*.local.md` dans .gitignore            │
│     → tokens, chemins absolus de la machine, secrets             │
└──────────────────────────────────────────────────────────────────┘
```

## Quoi commit, quoi NE PAS commit

### ✅ À commit (Git)

- `TAXONOMY.md`, `ROUTING.md`, `PROTOCOL_read.md`, `PROTOCOL_write.md`
- `INDEX.md`, `STORAGE.md`, `LLM_ADAPTERS.md`, `README.md`
- `adapters/` (templates)
- `scripts/`
- `FACTS/FACTS_user.md` **si** ne contient aucun secret (hardware, OS oui ; tokens non)
- Tous les `USR/*.md`, `ENT/*.md`, `PRJ/*.md`, `KNW/*.md`, `OPS/*.md`, `LOG/*.md` qui ne contiennent pas de secrets

### 🚫 À NE PAS commit (local uniquement)

- `*.local.md` (convention)
- `KNW/KNW_api_keys.local.md` ou similaire (tokens, mots de passe)
- `secrets/` si tu en crées un
- Fichier d'entrée LLM **si** posé en `~/.claude/CLAUDE.local.md` (Claude Code reconnaît cette convention nativement)
- `.cursor/rules/personal-*.mdc` si specifique à ta machine
- Toute info conjoint/famille sensible si tu hésites — préférer `*.local.md`

## Liaison fichier sensible ↔ fichier public

Pour les credentials, pattern recommandé :

`KNW/KNW_api_keys.md` (commit) :

```markdown
# Clés API

> Les valeurs sont dans `KNW_api_keys.local.md` (gitignored).

| Service | Variable d'env | Fichier local |
|---|---|---|
| OpenAI | `OPENAI_API_KEY` | KNW_api_keys.local.md §openai |
| Anthropic | `ANTHROPIC_API_KEY` | KNW_api_keys.local.md §anthropic |
```

`KNW/KNW_api_keys.local.md` (gitignored) :

```markdown
# (LOCAL — JAMAIS COMMIT)

## openai
sk-proj-…

## anthropic
sk-ant-…
```

## Sync multi-machines

1. **Repo PolyMind sur GitHub privé** (recommandé) ou GitLab/Gitea.
2. Sur la machine A : `git push`. Sur la machine B : `git pull`.
3. Les `*.local.md` ne traversent pas — chaque machine a sa version.
4. Les fichiers d'entrée LLM (`CLAUDE.md`, `AGENTS.md`) globaux dans `~/.claude/`, `~/.codex/`, etc. sont **par-machine**. Si tu veux les sync : tu les commit dans `adapters/` et tu reposes via `polymind-init.sh` après chaque pull.

## Mémoire "auto" du LLM (Claude Code, Cursor, etc.)

Certains LLMs ont leur propre mémoire automatique (ex : Claude Code écrit dans `~/.claude/projects/<slug>/memory/MEMORY.md`). **Cette couche est orthogonale à PolyMind** :

- Elle est **locale** par nature (home du LLM, pas dans le repo).
- Elle ne suit pas la taxonomie PolyMind.
- Recommandation : la **désactiver ou ignorer** — sinon variance entre la mémoire auto et PolyMind. L'adapter Claude (cf. `LLM_ADAPTERS.md`) précise comment.

## Récap décision

| Question | Réponse |
|---|---|
| Où je stocke un fait nouveau non sensible ? | Racine appropriée du repo PolyMind, commit |
| Où je stocke un token / API key ? | `*.local.md` à côté du fichier public, gitignored |
| Est-ce que je commit `~/.claude/CLAUDE.md` ? | Non si global (machine-specific). Oui si tu poses `./CLAUDE.md` à la racine d'un projet partagé |
| Mon pote sur sa machine, comment il a accès à ma config ? | `git pull` du repo PolyMind + `polymind-init.sh <son_llm>` |
| Mon pote partage-t-il mes secrets ? | Non — les `*.local.md` ne sont pas dans le repo |
