#!/bin/bash
set -e
if grep -R "repo delete" -n core scripts;then echo "ERROR: deletion commands found";exit 1;fi
echo "Safe."
