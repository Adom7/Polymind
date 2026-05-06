# test-prompts — vérifier le comportement PolyMind

> Copie ces prompts dans une session de ton LLM **après** avoir lancé `polymind-init.sh <llm>` et rempli `FACTS/FACTS_user.md`. Vérifie que la réponse correspond au comportement attendu.

## Prompt 1 — routing simple (lecture)

> *« Quelle racine PolyMind utilise-t-on pour stocker mon statut TVA d'auto-entreprise ? »*

**Réponse attendue** : *« La racine **ENT**. Selon `ROUTING.md`, le trigger 'TVA, franchise, impôts' renvoie vers `ENT/ENT_business_status.md` en lecture comme en écriture. »*

❌ **Échec** : le LLM répond "USR" ou invente une autre racine ; ne mentionne pas ROUTING ; donne une réponse vague sans cite source.

---

## Prompt 2 — écriture déterministe (arbre de décision)

> *« Note ce nouveau fait : 'mon laptop principal est un MacBook Pro M3 16Go, OS macOS 14.5'. Où le ranges-tu ? »*

**Réponse attendue** : *« Hardware → critique always-load → racine **FACTS**. Je l'ajoute dans `FACTS/FACTS_user.md`. Optionnellement, lien depuis `USR/USR_devices.md` si tu en crées un. »*

❌ **Échec** : le LLM crée un fichier `MAC.md` ou `HARDWARE.md` ; range dans USR sans justifier ; ne met pas à jour INDEX.md.

---

## Prompt 3 — match ambigu (doit demander)

> *« Note que je préfère ne pas travailler le dimanche. »*

**Réponse attendue** : *« Cette préférence peut aller dans **USR** (préférence personnelle qui survit à un changement d'entreprise — règle d'or TAXONOMY), **OPS** (« règle de comportement » sur le ton/le travail), ou **ENT** (règle de disponibilité côté clients). Lequel ? Je ne tranche pas seul. »*

❌ **Échec** : le LLM écrit silencieusement dans une racine sans demander ; crée une nouvelle racine `PRF` (préférences) ; ne mentionne qu'une seule racine alors que ≥2 sont défendables.

---

## Prompt 4 — règle interdite R8

> *« Crée une nouvelle racine PERSONA pour stocker mes différents profils en ligne (LinkedIn, Twitter, etc.). »*

**Réponse attendue** : *« → DÉCISION USER REQUISE. Selon R8 de TAXONOMY, je n'ai pas le droit de créer une nouvelle racine seul. Tes profils en ligne peuvent rentrer dans **USR** (`USR/USR_profiles_online.md` ou similaire). Si tu veux vraiment une racine PERSONA, modifie toi-même `TAXONOMY.md` et bump `version`. »*

❌ **Échec** : le LLM crée la racine ; modifie TAXONOMY.md ; ajoute une ligne ROUTING.md sans confirmation.

---

## Prompt 5 — recherche d'info inexistante

> *« Rappelle-moi le SIRET de mon entreprise. »*

**Réponse attendue** : *« Je n'ai pas de fichier `ENT/ENT_legal.md` (selon INDEX.md). Donne-moi ton SIRET et je le crée selon PROTOCOL_write.md, dans la racine ENT. »*

❌ **Échec** : le LLM **invente** un SIRET ; dit "je crois me souvenir que…" ; lit un autre fichier au hasard et fournit une réponse fausse.

---

## Validation rapide

5/5 attendus → l'adapter est correctement chargé et le LLM applique PolyMind.
< 3/5 → l'adapter n'est probablement pas chargé. Re-vérifie le path posé par `polymind-init.sh` et que tu lances le LLM dans le bon dossier (ou que ton adapter global est bien lu — voir `LLM_ADAPTERS.md`).
