---
type: cahier
root: META
slug: taxonomy
created: 2026-04-29
updated: 2026-04-29
status: active
version: v1
---

# TAXONOMY — PolyMind v1

*Document opérationnel. Lu à chaque écriture/lecture pour appliquer le routing déterministe.*

---

## 1. Les 6+1 racines — définitions précises

| Racine | Définition opérationnelle | Critère d'inclusion |
|---|---|---|
| **USR** | Tout ce qui décrit la **personne physique** : identité, préférences, contexte personnel, habitudes, état physique/mental, possessions perso (devices, voyages, famille). | "Si la personne change de carrière ou de société, ce fait reste vrai." |
| **ENT** | Toute **entité** dont la personne est partie prenante : société (AE, EURL, SAS), association, freelance, équipe, mission. SIRET, NAF, statut TVA, clients, factures. | "Si la personne disparaît, ce fait existe encore (ou survit dans une autre personne)." |
| **PRJ** | Tout **projet** ayant un objectif, un statut, un cycle de vie : actif, en pause, archivé. Code, vitrines, side-projects, projets méta (PolyMind lui-même). | "Ce fait disparaîtrait si le projet n'existait plus." |
| **KNW** | **Connaissance externe** acquise et conservée pour réutilisation : références techniques, docs outils, clés d'API, savoirs notés. | "Ce fait est vrai indépendamment de moi — il vient du monde extérieur." |
| **OPS** | **Règles opérationnelles** sur **comment** travailler : ton, rigueur, protocoles de session, conventions, workflows. | "Ce fait dicte un comportement, pas un état." |
| **LOG** | **Journal** : sessions, weekly, snapshots, tracking comportemental. | "Ce fait est daté et ne sera pas modifié rétroactivement." |
| ⚡ **FACTS** | **Faits durs always-load** : un sous-ensemble très restreint (hardware, identité, OS, contraintes de runtime) lu au session-start. Doublons partiels avec USR/ENT acceptés tant qu'ils sont en lecture-seule depuis `FACTS`. | "Si je ne sais pas ça en début de session, je vais me planter." |

**Règle d'or** : si un fait peut aller dans 2 racines, choisir celle dont la **disparition** rendrait l'autre toujours vraie. Exemples :
- Statut TVA → ENT (si l'entreprise change de forme, le statut TVA reste lié à l'entreprise, pas à la personne).
- Préférence "ne pas travailler avec l'alcool" → USR (lié à la personne, indépendant de l'entreprise).
- Hardware MacBook → FACTS (always-load) mais aussi USR (possession). On stocke dans FACTS et on link depuis USR si besoin.

---

## 2. Convention de nommage

### 2.1 Format universel
```
<RACINE>_<slug>.md
```
- Racine : majuscules, valeur ∈ {USR, ENT, PRJ, KNW, OPS, LOG, FACTS}.
- Slug : minuscules, snake_case, ASCII pur, jamais d'accents/espaces/tirets.
- Pas de TEMPOREL (sauf LOG qui peut avoir `LOG_sessions_<YYYY-W<NN>>.md`).

### 2.2 Sous-branches (si nécessaire)
Format : `<RACINE>_<domaine>_<sous_domaine>.md`. Exemple : `USR_devices_phones.md`.

Mais préférer la **profondeur 1 par défaut** : `USR_devices.md` qui regroupe phones, laptops, etc., sauf si le fichier dépasse ~400 lignes ou ~3 sous-domaines disjoints.

### 2.3 Cohabitation avec une nomenclature préexistante
Si tu poses PolyMind sur un vault déjà organisé (avec ses propres préfixes), garde les préfixes existants comme **alias** vers les racines PolyMind. Migration progressive, fichier par fichier.

---

## 3. Protocole d'extension — 8 règles

### R1 — Avant de créer une node
Toujours vérifier qu'une racine ou un fichier existant ne couvre pas déjà le sujet. Recherche par :
1. `grep -ri "<mot-clé sémantique>" <racine>/` sur les noms de fichiers ET le contenu.
2. Si match ambigu → demander à l'utilisateur, **ne pas trancher seul**.

### R2 — Racine vs sous-branche
Nouvelle racine **uniquement** si le domaine est **sémantiquement disjoint** des 6+1 existantes. En pratique, **aucune nouvelle racine ne devrait être créée par un LLM** — décision user obligatoire (R8).

### R3 — Convention de nommage stricte
Format §2.1. Pas de variation, pas d'invention de préfixe.

### R4 — Promotion sous-branche → racine
Si une sous-branche atteint **N fichiers** (V1 : N=8) ou **dépasse une racine existante en volume**, candidate à promotion. **Décision user obligatoire**, jamais automatique.

### R5 — Doublons sémantiques (détection + fusion)
- À chaque écriture : vérifier qu'aucun fichier `<racine>/*` ne couvre déjà 70%+ du contenu.
- Si oui → fusionner et supprimer le doublon, **noter le mapping `<ancien_chemin> → <nouveau_chemin>`** dans `LOG/LOG_migrations.md`.
- Si non clair → ne pas écrire, demander à l'utilisateur.

### R6 — Format des liens entre nodes
- **Canonique (machine-readable)** : champ `links: [<slug_autre_node>, ...]` dans le frontmatter YAML.
- **Lisible humain** : wikilinks `[[<slug>]]` ou markdown links `[label](relative/path.md)` dans le corps.
- **Règle** : tout lien dans le corps **doit** avoir une entrée correspondante dans `links:`.
- Liens unidirectionnels par défaut. Pour bidirectionnel, ajouter dans les deux nodes.

### R7 — Archivage (jamais suppression silencieuse)
- Un fichier devenu obsolète passe en `<RACINE>/archive/<RACINE>_<slug>.md`.
- Frontmatter mis à jour : `status: archived`, `archived_date: YYYY-MM-DD`.
- Note "→ archivé" laissée 1 sprint dans `INDEX.md`.
- Suppression définitive **uniquement** par décision user (R8).

### R8 — Décisions user-only (jamais auto)
Le LLM n'a **pas** le droit de prendre seul ces décisions :
- Créer une **nouvelle racine**.
- **Promouvoir** une sous-branche en racine.
- **Supprimer** définitivement un fichier (différent d'archiver).
- **Renommer** un préfixe ou un slug existant.
- **Modifier** la `TAXONOMY.md` ou le `ROUTING.md`.

Pour ces actions : flag explicite `→ DÉCISION USER REQUISE` dans la réponse, et stop.

---

## 4. Format frontmatter standardisé

```yaml
---
type: <usr|ent|prj|knw|ops|log|facts|cahier|note|...>
root: <USR|ENT|PRJ|KNW|OPS|LOG|FACTS>
slug: <slug_ASCII_snake_case>
created: YYYY-MM-DD
updated: YYYY-MM-DD
status: <active|archived|draft>
links: [<slug_autre_node>, ...]
projet: <slug_projet>            # optionnel
tags: [<tag>, ...]               # optionnel
---
```

**Règle** : `root` est **obligatoire**. Sans `root`, le fichier n'est pas valide PolyMind.

---

## 5. Cas particuliers / FAQ

### Q1 : Un fait concerne USR ET ENT.
→ Stocker dans la racine dont la disparition laisse l'autre vraie. Lien explicite via `links:`.

### Q2 : Un fait change de racine au fil du temps.
→ Migrer le fichier (R7 : archive l'ancien, crée le nouveau, note la migration dans `LOG/LOG_migrations.md`).

### Q3 : Un fait est multi-instances (ex: chronotype = USR_profile + FACTS).
→ Stockage canonique dans **une seule** racine. Les autres fichiers **lien** vers le canonique, pas duplication.

### Q4 : Un fait n'a pas de racine évidente.
→ NE PAS INVENTER. Poser la question à l'utilisateur. Fallback : `LOG/dump/` (zone temporaire à reclasser).

---

## 6. Versionnage de la taxonomie

- TAXONOMY.md a un champ `version:` dans le frontmatter.
- V1 = définition initiale (ce document).
- V1.x = ajouts non-breaking (nouveau trigger dans ROUTING, FAQ enrichie).
- V2 = breaking changes (nouvelle racine, refonte protocoles).
- Toute V majeure = décision user (R8) + commit annoté `taxonomy: vN — <résumé>`.

---

## 7. Liens

- Protocole de lecture : `PROTOCOL_read.md`
- Protocole d'écriture : `PROTOCOL_write.md`
- Routing rules : `ROUTING.md`
- Index : `INDEX.md`
