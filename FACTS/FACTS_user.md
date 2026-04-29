---
type: facts
root: FACTS
slug: facts_user
created: 2026-04-29
updated: 2026-04-29
status: active
links: []
---

# FACTS_user — always-load

> **Rôle** : faits durs chargés par le LLM à chaque session-start. Sans ça, il se plante.
>
> **Règle** : restreint au minimum vital. Si un fait peut attendre la lecture lazy, il **n'a pas sa place ici**.

---

## Identité

- **Nom / pseudo** : `<à remplir>`
- **Langue principale** : `<fr|en|...>`
- **Fuseau horaire** : `<ex: Europe/Paris>`

## Hardware

- **Machine principale** : `<ex: MacBook Pro M3, 16 Go>`
- **OS** : `<ex: macOS 15.3>`
- **Shell** : `<ex: zsh 5.9>`

## Runtime / environnement de travail

- **Path racine projet** : `<ex: /Users/.../polymind/>`
- **Outils LLM utilisés** : `<ex: Claude Code, Codex, ChatGPT desktop>`
- **Stack courante** : `<ex: Python 3.12, Node 20, Docker>`

## Contraintes dures

- `<ex: pas de connexion internet sur la machine de prod>`
- `<ex: latence élevée sur le SSH du serveur perso>`

## Préférences de communication LLM

- **Ton** : `<ex: direct, sans flatterie>`
- **Format réponse** : `<ex: concis, listes à puces, code en bloc>`
- **Langue réponse** : `<ex: français>`

---

## Mode d'emploi

- Remplir uniquement les champs pertinents.
- Supprimer les sections inutiles (mais garder Identité + Runtime au minimum).
- Toute modif : update `updated:` dans le frontmatter.
- **Ne pas mettre ici** : préférences fines, historique, faits projet. → USR / OPS / PRJ.
