---
type: routing
root: META
slug: routing
created: 2026-04-29
updated: 2026-04-29
status: active
version: v1
---

# ROUTING — table déclarative

*Source de vérité du routing trigger → fichier. Lue par le LLM à chaque message (cf. `PROTOCOL_read.md` étape 3).*

---

## Règles d'usage

- **Lecture** : match du trigger → lire la colonne *Lecture obligatoire* avant de répondre.
- **Écriture** : un fait nouveau matche un trigger → écrire dans la colonne *Écriture candidate* (sauf si arbre de décision dit autrement, cf. `PROTOCOL_write.md`).
- **Modification de cette table** : R8 — décision user obligatoire.
- **Match ambigu** (plusieurs lignes) : ne pas trancher seul, demander à l'user.

---

## Table baseline (universelle)

| Trigger (mots-clés ou intent) | Lecture obligatoire | Écriture candidate |
|---|---|---|
| identité, nom, profil, prénom, qui suis-je | USR/USR_profile.md, FACTS/FACTS_user.md | USR/USR_profile.md |
| chronotype, sommeil, énergie, rythme | USR/USR_profile.md | USR/USR_profile.md |
| voyages, pays, hôtel, vol | USR/USR_travels.md | USR/USR_travels.md |
| téléphone, ordinateur, hardware perso, device | USR/USR_devices.md, FACTS/FACTS_user.md | USR/USR_devices.md |
| famille, parent, frère, sœur, conjoint, enfant | USR/USR_family.md | USR/USR_family.md |
| santé, médecin, traitement | USR/USR_health.md | USR/USR_health.md |
| préférence personnelle, goûts, valeurs | USR/USR_profile.md | USR/USR_profile.md |
| TVA, franchise, impôts, URSSAF, fiscalité | ENT/ENT_business_status.md | ENT/ENT_business_status.md |
| SIRET, NAF, statut juridique, immat | ENT/ENT_legal.md | ENT/ENT_legal.md |
| client, devis, facture, contrat | ENT/ENT_clients.md | ENT/ENT_clients.md |
| projet `<nom>`, `<nom de projet>` | PRJ/PRJ_`<slug>`.md | PRJ/PRJ_`<slug>`.md |
| API key, token, credential, secret | KNW/KNW_api_keys.md | KNW/KNW_api_keys.md |
| outil, stack, framework, doc externe | KNW/KNW_`<tool>`.md | KNW/KNW_`<tool>`.md |
| règle, comportement, ton, rigueur, protocole | OPS/OPS_`<topic>`.md | OPS/OPS_`<topic>`.md |
| session start, début session, démarrage | FACTS/*.md, OPS/OPS_session_protocol.md, INDEX.md | LOG/LOG_sessions.md |
| fin de session, weekly, récap | OPS/OPS_session_protocol.md | LOG/LOG_sessions.md, LOG/LOG_weekly_`<YYYY-W<NN>>`.md |
| mémoire, taxonomie, polymind, vault | TAXONOMY.md, INDEX.md | (R8 — décision user) |

---

## Personnalisation

Cette table est **générique**. Pour adapter à ton vocabulaire :

1. **Ajouter une ligne** : trigger spécifique (ex: "client ACME", "projet Helix") + fichier(s) existant(s).
2. **Supprimer une ligne** : si tu ne stockes jamais ce type de fait.
3. **Ne jamais** modifier le format des colonnes ni l'ordre de précédence.

Après modif : update le frontmatter `updated:` et logge dans `LOG/LOG_migrations.md`.

---

## Fallback (aucun trigger ne matche)

Ordre de fallback :
1. Grep large sur `INDEX.md`.
2. Grep sur les noms de fichiers de toutes les racines (`ls <racine>/`).
3. Demander à l'utilisateur (« Je ne trouve pas où ranger ça, tu vois ça dans quelle racine ? »).

**Jamais** d'écriture sans match explicite ou validation user.

---

## Liens

- Taxonomie : `TAXONOMY.md`
- Lecture : `PROTOCOL_read.md`
- Écriture : `PROTOCOL_write.md`
- Index : `INDEX.md`
