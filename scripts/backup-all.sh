#!/bin/bash
set -e
ORG="ram133"
gh repo list $ORG --limit 200 --json name -q '.[[].name' | while read r;do node -e "import('./core/modules/backup-manager.js').then(m=>m.backupRepo('$r'))";done
