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
4. Pointe ton LLM vers ce dossier comme racine mémoire :
   - **Claude Code** : copie `PROTOCOL_read.md` + `PROTOCOL_write.md` dans ton `CLAUDE.md` global, ou pointe `MEMORY.md` vers ce dossier.
   - **Codex / autres** : préfixe tes prompts avec un loader qui lit `INDEX.md` + `FACTS/*.md`.

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

Version **v1 — design** (Sprint 1 livré). Sprint 2 = implémentation / migration progressive de vaults existants. Sprint 3+ = adaptateurs multi-LLM (Codex, Mythos…) et publication open source large.

Projet pensé en MAs (milestones) avec saves fréquents. Branche de dev courante : voir l'arbre des branches.

---

## Licence

MIT. Cf. `LICENSE`.
