#!/bin/bash
poetry version $1
git add pyproject.toml
git commit -m "v$(poetry version -s)"
git push
PRERELEASE=""
if [[ $1 == "pre"* ]]; then
    PRERELEASE="--prerelease"
fi
gh release create "v$(poetry version -s)" --generate-notes --target=$(git rev-parse --abbrev-ref HEAD) $PRERELEASE
poetry version