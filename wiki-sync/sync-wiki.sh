#!/usr/bin/bash
set -euo pipefail
DEST_DIR="docs/lxqt.wiki"

git clone --depth 1 https://github.com/lxqt/lxqt.wiki.git wiki-sync/tmp-wiki
rm -rf "${DEST_DIR:?}"/*
cp -R wiki-sync/tmp-wiki/*.md "${DEST_DIR}/"
cp  docs/index.md ${DEST_DIR}/
cp -a docs/_assets ${DEST_DIR}/
rm -rf wiki-sync/tmp-wiki
