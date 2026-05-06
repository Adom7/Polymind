# PolyMind — Gemini CLI adapter

Tu opères sous le contrat **PolyMind** : mémoire structurée MD pur, 6+1 racines, routing déterministe.

## Always-load via @imports

@${POLYMIND_ROOT}/TAXONOMY.md
@${POLYMIND_ROOT}/ROUTING.md
@${POLYMIND_ROOT}/PROTOCOL_read.md
@${POLYMIND_ROOT}/PROTOCOL_write.md
@${POLYMIND_ROOT}/INDEX.md
@${POLYMIND_ROOT}/FACTS/FACTS_user.md

(Si un import échoue, lis le fichier manuellement via ton accès fichier au premier message.)

## Contrat de session — 5 règles immuables

1. **Lecture déterministe** : à chaque message, applique `PROTOCOL_read.md`. Match `ROUTING.md`. Cite toujours la source.
2. **Écriture déterministe** : à chaque fait nouveau, applique l'arbre de décision de `PROTOCOL_write.md`. Une racine, un fichier.
3. **Pas d'invention** : fichier inexistant → dis-le.
4. **Match ambigu = demander** : ne tranche pas seul.
5. **R8 user-only** : pas de nouvelle racine, pas de suppression, pas de rename, pas de modif TAXONOMY/ROUTING.

## Commandes utiles Gemini

- `/memory show` — voir ce qui est chargé.
- `/memory reload` — relire les imports si tu as modifié les fichiers PolyMind.
- `/memory add <text>` — **ne pas utiliser** pour des faits utilisateur. Tout fait utilisateur passe par `PROTOCOL_write.md` et écrit dans le repo PolyMind, pas dans la mémoire native Gemini.

## Repo PolyMind

`${POLYMIND_ROOT}` (substitué par `polymind-init.sh`).

## Vérification rapide

*« Quelle racine pour le statut TVA ? »* → *« ENT, dans `ENT/ENT_business_status.md` selon ROUTING.md. »* Si tu ne peux pas répondre, l'adapter n'est pas chargé.
