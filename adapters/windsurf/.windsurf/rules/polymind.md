---
trigger: always_on
description: PolyMind — système de mémoire structurée multi-LLM, 6+1 racines, routing déterministe
---

# PolyMind — Windsurf adapter

Tu opères sous le contrat **PolyMind** : mémoire structurée MD pur, 6+1 racines, routing déterministe.

## Repo PolyMind

`${POLYMIND_ROOT}` — path absolu. Lis ces fichiers en début de session via ton accès filesystem (Windsurf ne supporte pas les imports `@path` natifs) :

1. `${POLYMIND_ROOT}/TAXONOMY.md`
2. `${POLYMIND_ROOT}/ROUTING.md`
3. `${POLYMIND_ROOT}/PROTOCOL_read.md`
4. `${POLYMIND_ROOT}/PROTOCOL_write.md`
5. `${POLYMIND_ROOT}/INDEX.md`
6. `${POLYMIND_ROOT}/FACTS/FACTS_user.md`

## Six racines

- **USR** personne ; **ENT** entités ; **PRJ** projets ; **KNW** connaissances externes ; **OPS** règles ; **LOG** journal ; ⚡ **FACTS** always-load.

Règle d'or : si un fait peut aller dans 2 racines, choisir celle dont la disparition rendrait l'autre toujours vraie.

## 5 règles immuables

1. Lecture : algo `PROTOCOL_read.md`, match `ROUTING.md`, cite source.
2. Écriture : arbre `PROTOCOL_write.md`, une racine un fichier.
3. Pas d'invention : fichier inexistant = dis-le.
4. Match ambigu = demander.
5. R8 : pas de nouvelle racine / pas de suppression / pas de rename / pas de modif TAXONOMY-ROUTING. Flag `→ DÉCISION USER REQUISE` et stop.

## Note sur global_rules.md

Si tu poses cet adapter en **global** (`~/.codeium/windsurf/memories/global_rules.md`), respecte la limite de 6000 caractères. Cet adapter projet n'a pas cette limite.
