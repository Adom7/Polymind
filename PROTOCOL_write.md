---
type: protocole
root: META
slug: protocol_write
created: 2026-04-29
updated: 2026-04-29
status: active
version: v1
---

# PROTOCOL_write — écriture déterministe

*Algorithme à appliquer par le LLM quand un fait nouveau doit être persisté.*

---

## Algorithme

```
Quand l'utilisateur donne un fait nouveau OU le LLM produit un fait persistable :

1. Identifier le fait :
   1.1 Quoi (le contenu).
   1.2 Volatilité : permanent (USR/ENT/KNW), évolutif (PRJ/OPS), daté (LOG), critique always-load (FACTS).

2. Choisir la racine (arbre de décision) :

   Le fait est-il un fait dur dont l'absence en début de session = échec ?
   ├── Oui → FACTS
   └── Non
       │
       Le fait décrit-il un comportement / une règle / un protocole ?
       ├── Oui → OPS
       └── Non
           │
           Le fait est-il daté et immuable rétroactivement ?
           ├── Oui → LOG
           └── Non
               │
               Le fait vient-il d'une source externe (doc, API, outil) ?
               ├── Oui → KNW
               └── Non
                   │
                   Le fait concerne-t-il un projet identifié ?
                   ├── Oui → PRJ
                   └── Non
                       │
                       Le fait survit-il à un changement de société de la personne ?
                       ├── Oui → USR
                       └── Non → ENT

3. Choisir le fichier dans la racine :
   3.1 Appliquer R1 (TAXONOMY) : vérifier doublons via grep + INDEX.
   3.2 Si fichier existant matche le sous-domaine → écrire dedans.
   3.3 Sinon → créer selon convention de nommage (TAXONOMY §2).
   3.4 Toujours mettre à jour `updated: YYYY-MM-DD` et `links:` si pertinent.

4. Mettre à jour INDEX.md :
   4.1 Si nouveau fichier créé → ajouter ligne dans INDEX.md sous la bonne racine.
   4.2 Si fichier renommé/archivé → mettre à jour la ligne (et noter dans LOG/LOG_migrations.md).

5. Frontmatter obligatoire (TAXONOMY §4) :
   - root, slug, created, updated, status, links.

6. Commit (git) avec message descriptif si versionnement actif.
```

---

## Cas où le LLM ne doit PAS écrire

Flag explicite `→ DÉCISION USER REQUISE`, et stop, dans ces cas :
- Créer une **nouvelle racine**.
- **Promouvoir** une sous-branche en racine (R4).
- **Supprimer** définitivement un fichier.
- **Renommer** un slug ou un préfixe existant.
- **Modifier** TAXONOMY.md ou ROUTING.md.
- Doublon sémantique non-clair (R5).
- Pas de racine évidente après arbre de décision (FAQ Q4).

---

## Doublons sémantiques (R5)

Avant chaque création de fichier :
1. `grep -ril "<concept-clé>" <racine>/`
2. Si match ≥ 1 fichier qui couvre 70%+ du sujet → **écrire dans l'existant**, pas en créer un nouveau.
3. Si match flou → demander à l'utilisateur.

---

## Archivage (R7)

- Déplacer en `<RACINE>/archive/<RACINE>_<slug>.md`.
- Frontmatter : `status: archived`, ajouter `archived_date: YYYY-MM-DD`.
- Note "→ archivé" dans `INDEX.md` (section *Archivés*) pendant 1 sprint.
- Logger dans `LOG/LOG_migrations.md` : `<ancien_chemin> → archive/`.

---

## Liens

- Taxonomie : `TAXONOMY.md`
- Lecture : `PROTOCOL_read.md`
- Routing rules : `ROUTING.md`
- Index : `INDEX.md`
