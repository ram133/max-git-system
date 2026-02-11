#!/bin/bash
set -e
NAME=$1
node -e "import('./core/modules/repo-manager.js').then(m=>m.createRepo('$NAME'))"
node -e "import('./core/modules/repo-manager.js').then(m=>m.setDefaultBranch('$NAME'))"
node -e "import('./core/modules/pages-manager.js').then(m=>m.enablePages('$NAME'))"
echo "Repo $NAME created."
