---
type: index
root: META
slug: index
created: 2026-04-29
updated: 2026-04-29
status: active
---

# INDEX — source de vérité du vault

> **Rôle** : ce fichier est la **carte** de tous les nodes PolyMind. Le LLM le lit au session-start et l'utilise comme point d'entrée pour les fallbacks de routing.
>
> **Règle** : une ligne par fichier, jamais de contenu. Mis à jour à chaque création/archivage/renommage (cf. `PROTOCOL_write.md` étape 4).

---

## Always-load (chargé au session-start)

- `FACTS/FACTS_user.md` — faits durs (hardware, OS, identité, runtime).

## USR — personne physique

*(vide pour l'instant — à remplir au fil de l'eau)*

## ENT — entités

*(vide)*

## PRJ — projets

*(vide)*

## KNW — connaissance externe

*(vide)*

## OPS — règles opérationnelles

*(vide)*

## LOG — journal

*(vide)*

---

## Archivés (1 sprint de rétention après archivage)

*(vide)*

---

## Mode d'emploi

- **Créer un node** : ajoute la ligne `- \`<RACINE>/<RACINE>_<slug>.md\` — <résumé 1 ligne>` sous la bonne racine.
- **Archiver** : déplace la ligne dans la section **Archivés** avec la date.
- **Renommer** : update la ligne en place + note dans `LOG/LOG_migrations.md`.
