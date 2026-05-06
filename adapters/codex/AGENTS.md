# PolyMind — OpenAI Codex CLI adapter

Tu opères sous le contrat **PolyMind** : système de mémoire structurée MD pur, 6+1 racines, routing déterministe.

## Repo PolyMind

`${POLYMIND_ROOT}` — path absolu vers le repo PolyMind. Codex CLI ne supporte pas les imports `@path` natifs ; tu liras les fichiers ci-dessous **à la demande** au début de chaque session :

1. `${POLYMIND_ROOT}/TAXONOMY.md` — racines + règles d'extension
2. `${POLYMIND_ROOT}/ROUTING.md` — table trigger → fichier
3. `${POLYMIND_ROOT}/PROTOCOL_read.md` — algorithme de lecture
4. `${POLYMIND_ROOT}/PROTOCOL_write.md` — algorithme d'écriture
5. `${POLYMIND_ROOT}/INDEX.md` — annuaire des fichiers
6. `${POLYMIND_ROOT}/FACTS/FACTS_user.md` — faits durs always-load

**Au début de chaque session**, lis ces fichiers (utilise `cat` ou ton accès fichier) avant de répondre au premier message qui exige une lecture/écriture.

## Contrat de session — 5 règles immuables

1. **Lecture déterministe** : applique l'algorithme de `PROTOCOL_read.md`. Match `ROUTING.md`. Cite la source.
2. **Écriture déterministe** : applique l'arbre de décision de `PROTOCOL_write.md`. Une racine, un fichier, jamais d'invention de chemin.
3. **Pas d'invention** : fichier inexistant → dis-le. Pas de "souvenir" fabriqué.
4. **Match ambigu = demander** : ne tranche pas seul.
5. **R8 user-only** : tu ne crées pas de nouvelle racine, ne supprimes pas, ne renommes pas, ne modifies pas TAXONOMY/ROUTING. Flag `→ DÉCISION USER REQUISE` et stop.

## Six racines

- **USR** — la personne (identité, préférences, devices, voyages)
- **ENT** — entités (sociétés, missions, freelance ; SIRET, TVA, clients)
- **PRJ** — projets (objectif, statut, cycle de vie)
- **KNW** — connaissances externes (docs outils, références)
- **OPS** — règles opérationnelles (ton, rigueur, protocoles)
- **LOG** — journal (sessions, weekly)
- ⚡ **FACTS** — faits durs always-load (hardware, OS, identité)

## Comment écrire

```
1. Identifier le fait + sa volatilité.
2. Choisir la racine (arbre de décision dans PROTOCOL_write.md).
3. R1 vérifier doublon (grep). R5 fusionner si ≥70% recouvrement.
4. Mettre à jour `updated: YYYY-MM-DD` ; ajouter ligne dans INDEX.md si nouveau fichier.
5. Commit : `<racine>: <action> <slug>`.
```

## Vérification rapide

Demande-toi *« quelle racine pour le statut TVA ? »* → réponse attendue : *« ENT, dans `ENT/ENT_business_status.md` selon ROUTING.md. »*

Si tu ne peux pas répondre → l'adapter n'est pas chargé, signale-le.
