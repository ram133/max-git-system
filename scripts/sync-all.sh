#!/bin/bash
set -e
ORG="ram133"
gh repo list $ORG --limit 200 --json name -q '.[].name' | while read r;do gh repo sync $ORG/$r;done
