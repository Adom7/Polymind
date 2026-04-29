---
type: protocole
root: META
slug: protocol_read
created: 2026-04-29
updated: 2026-04-29
status: active
version: v1
---

# PROTOCOL_read — lecture déterministe

*Algorithme à appliquer par le LLM à chaque message utilisateur.*

---

## Algorithme

```
À chaque message utilisateur :

1. Si session-start :
   1.1 Charger toutes les FACTS/*.md (always-load).
   1.2 Charger INDEX.md.
   1.3 Stop ici si aucun intent clair.

2. Extraction intent :
   2.1 Identifier les mots-clés et l'intent du message.
   2.2 Si projet mentionné : noter le slug projet.

3. Routing :
   3.1 Match sur ROUTING.md.
   3.2 Si match net (1 ligne) → lire les fichiers de la colonne "Lecture obligatoire".
   3.3 Si match ambigu (plusieurs lignes) → fallback :
       - Demander à l'utilisateur (« Je vois X et Y, tu parles de quoi ? »).
   3.4 Si pas de match → fallback :
       - Grep large sur INDEX.md.
       - Si toujours rien → poser la question pour cadrer.

4. Lecture contextuelle :
   4.1 Lire les fichiers dans l'ordre de priorité (FACTS d'abord, INDEX ensuite, PRJ/USR/ENT après).
   4.2 Ne lire que les sections pertinentes (pas de re-charge brutale du fichier entier si non nécessaire).

5. Réponse :
   5.1 Construire la réponse à partir des fichiers lus.
   5.2 Citer le fichier source de chaque fait (ex: « selon ENT_business_status.md L12 »).
   5.3 Si une info manque → demander à l'utilisateur, **jamais inventer**.
```

---

## Règles dures

- **Toujours** lire les fichiers de la colonne "Lecture obligatoire" du `ROUTING.md` avant de répondre, même si le LLM "pense connaître" l'info.
- **Jamais** déduire l'emplacement d'une info en dehors du `ROUTING.md` ou de l'`INDEX.md`.
- **Jamais** inventer un fait absent. Si une info manque, demander.
- **Citer** la source. Traçabilité = condition de l'auditabilité.

---

## Fallback ambigu

Quand plusieurs lignes du `ROUTING.md` matchent un même trigger : **ne pas trancher seul**. Formulation type :

> « Ta question peut concerner [X] ou [Y]. Tu vises lequel ? »

Alternative : lire les deux et expliciter dans la réponse « Selon X… selon Y… ». Mais **jamais** un choix silencieux.

---

## Liens

- Taxonomie : `TAXONOMY.md`
- Écriture : `PROTOCOL_write.md`
- Routing rules : `ROUTING.md`
