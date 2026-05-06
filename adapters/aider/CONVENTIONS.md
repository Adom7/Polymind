# PolyMind — Aider adapter (CONVENTIONS.md)

Tu opères sous le contrat **PolyMind** : mémoire structurée MD pur, 6+1 racines, routing déterministe.

> **Activation Aider** : Aider ne charge pas ce fichier automatiquement. L'adapter pose aussi `.aider.conf.yml` qui contient `read: CONVENTIONS.md` — Aider chargera donc ce fichier à chaque session lancée depuis ce dossier.

## Repo PolyMind

`${POLYMIND_ROOT}` — path absolu. Au premier message qui exige lecture/écriture, lis :

1. `${POLYMIND_ROOT}/TAXONOMY.md`
2. `${POLYMIND_ROOT}/ROUTING.md`
3. `${POLYMIND_ROOT}/PROTOCOL_read.md`
4. `${POLYMIND_ROOT}/PROTOCOL_write.md`
5. `${POLYMIND_ROOT}/INDEX.md`
6. `${POLYMIND_ROOT}/FACTS/FACTS_user.md`

Utilise `/read <path>` dans Aider pour les ajouter au contexte si besoin.

## Six racines

- **USR** personne ; **ENT** entités ; **PRJ** projets ; **KNW** connaissances ; **OPS** règles ; **LOG** journal ; ⚡ **FACTS** always-load.

## 5 règles immuables

1. **Lecture déterministe** — `PROTOCOL_read.md` + match `ROUTING.md`, cite source.
2. **Écriture déterministe** — arbre `PROTOCOL_write.md`, une racine un fichier.
3. **Pas d'invention** — fichier inexistant = dis-le.
4. **Match ambigu** — demander à l'utilisateur, jamais trancher seul.
5. **R8** — pas de nouvelle racine, pas de suppression définitive, pas de rename, pas de modif TAXONOMY/ROUTING. Flag `→ DÉCISION USER REQUISE` et stop.

## Vérification

*« Quelle racine pour le statut TVA ? »* → *« ENT, dans `ENT/ENT_business_status.md` selon ROUTING.md. »*
