# Contributing to PolyMind

Merci de l'intérêt. PolyMind est un kit de **mémoire structurée pour LLM**, MD pur, déterministe. Les contributions doivent préserver ces deux contraintes.

## Pré-requis

- Bash 4+, `git`, un éditeur.
- Lire d'abord : [`TAXONOMY.md`](TAXONOMY.md) (le contrat), [`PROTOCOL_read.md`](PROTOCOL_read.md), [`PROTOCOL_write.md`](PROTOCOL_write.md), [`LLM_ADAPTERS.md`](LLM_ADAPTERS.md).

## Workflow

1. Fork le repo.
2. Branche dédiée : `feat/<nom>` ou `fix/<nom>`.
3. Modifs.
4. `bash scripts/polymind-validate.sh .` → score doit rester **100/100**. Si la PR baisse le score, elle est refusée.
5. PR vers `main` avec description claire + cas d'usage.

## Types de contributions bienvenues

### Nouvel adapter LLM
- Créer `adapters/<llm>/...` avec le fichier d'entrée natif au format attendu.
- Mettre à jour le tableau de [`LLM_ADAPTERS.md`](LLM_ADAPTERS.md) avec la **source officielle** (URL doc) prouvant le path et le format.
- Ajouter le case `<llm>)` dans `scripts/polymind-init.sh`.
- Ajouter la pénalité dans `scripts/polymind-validate.sh` si l'adapter est manquant.

### Enrichir `ROUTING.md`
- Ajouter une ligne uniquement si elle est **génériquement utile** (pas spécifique à un user).
- Justifier dans la PR : combien d'utilisateurs en bénéficient ?
- Ne jamais retirer de ligne existante sans deprecation cycle (1 release de warning).

### Améliorer les protocoles ou la TAXONOMY
- Tout changement breaking = bump `version:` dans le frontmatter du fichier concerné.
- Documenter le rationnel et l'impact migration dans la PR.

### Outillage
- Pre-commit hooks (gitleaks, frontmatter validator).
- GitHub Action qui run `polymind-validate.sh` à chaque PR.
- Linter MD spécifique aux conventions PolyMind.

## Ce qui n'est PAS bienvenu

- Cas d'usage perso d'un user (ça va dans son propre repo, pas dans le kit).
- Dépendance à un outil externe non-essentiel sans flag opt-in.
- Refactor cosmétique massif sans gain fonctionnel.
- Suppression de l'isolation MD pur (pas de DSL custom, pas de binaire compilé).

## Style

- Markdown : suivre la convention existante des fichiers déjà présents.
- Bash : `set -euo pipefail`, sortie human-readable + JSON sur stderr quand pertinent.
- Frontmatter YAML : champs obligatoires `type`, `root`, `slug`, `created`, `updated`, `status`. Les fichiers cœur (TAXONOMY, ROUTING, PROTOCOL_*, INDEX, STORAGE, LLM_ADAPTERS) utilisent `root: META`.

## Code of Conduct

Bienveillance, rigueur. Pas d'attaque personnelle. Critique du code, pas du contributeur.

## License

En soumettant une PR, tu acceptes que ta contribution soit publiée sous la même licence MIT.
