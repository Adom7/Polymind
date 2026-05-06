# PolyMind — Claude Code adapter

Tu es connecté à un système de mémoire structurée **PolyMind**. Au démarrage de chaque session, lis les fichiers ci-dessous **dans cet ordre**, puis applique scrupuleusement les protocoles.

## Always-load (au session-start)

@${POLYMIND_ROOT}/TAXONOMY.md
@${POLYMIND_ROOT}/ROUTING.md
@${POLYMIND_ROOT}/PROTOCOL_read.md
@${POLYMIND_ROOT}/PROTOCOL_write.md
@${POLYMIND_ROOT}/INDEX.md
@${POLYMIND_ROOT}/FACTS/FACTS_user.md

## Contrat de session — 5 règles immuables

1. **Lecture déterministe** : à chaque message, applique l'algorithme de `PROTOCOL_read.md`. Match `ROUTING.md` avant de répondre. Cite toujours la source.
2. **Écriture déterministe** : à chaque fait nouveau, applique l'arbre de décision de `PROTOCOL_write.md`. Une racine, un fichier — jamais d'invention de chemin.
3. **Pas d'invention** : si un fichier n'existe pas, dis-le. Ne fabrique jamais de "souvenir" plausible.
4. **Match ambigu = demander** : 2 lignes de ROUTING peuvent matcher → demander à l'utilisateur, ne jamais trancher seul.
5. **R8 user-only** : tu n'as pas le droit de créer une nouvelle racine, supprimer définitivement, renommer un slug, modifier `TAXONOMY.md` ou `ROUTING.md`. Pour ces cas : flag `→ DÉCISION USER REQUISE` et stop.

## Mémoire native vs PolyMind

Claude Code peut écrire dans `~/.claude/projects/<slug>/memory/MEMORY.md` (auto-memory). **Ignore cette couche** au profit de PolyMind. Si tu as un fait à persister, il va dans le repo PolyMind selon `PROTOCOL_write.md`, pas dans la mémoire auto.

Exception : la mémoire auto reste utile pour des préférences purement Claude-Code (hooks, skills) qui n'ont pas leur place dans PolyMind. Mais pour tout fait utilisateur, projet, entité, règle → PolyMind.

## Repo PolyMind

Path résolu : `${POLYMIND_ROOT}` (substitué par `polymind-init.sh`).

## Vérification rapide

Si l'utilisateur te demande *« quelle racine pour le statut TVA ? »*, tu dois pouvoir répondre :
*« ENT, fichier `ENT/ENT_business_status.md` selon ROUTING.md. »*

Si tu ne sais pas répondre → l'adapter n'est pas correctement chargé, dis-le clairement.
