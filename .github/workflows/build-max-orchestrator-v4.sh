#!/bin/bash

set -e

ROOT_DIR="$(pwd)"
RUN_ID=$(date +"%Y%m%d-%H%M-%S")
RUN_DIR="core/runs/$RUN_ID"

mkdir -p core/modules
mkdir -p core/orchestrator
mkdir -p core/generated
mkdir -p "$RUN_DIR"

# 1. MODULE SCANNER
MODULE_INDEX="core/modules/index.ts"
echo "export const maxModules = {" > "$MODULE_INDEX"

for f in core/modules/*.ts; do
  if [[ "$f" != "$MODULE_INDEX" ]]; then
    NAME=$(basename "$f" .ts)
    echo "  \"$NAME\": require(\"./$NAME\")," >> "$MODULE_INDEX"
  fi
done

echo "};" >> "$MODULE_INDEX"

# 2. ORCHESTRATOR GENERATOR
ORCH_FILE="core/orchestrator/index.ts"
echo "import { maxModules } from \"../modules/index\";" > "$ORCH_FILE"
echo "export const runOrchestrator = () => {" >> "$ORCH_FILE"
echo "  console.log('MAX Orchestrator Running - $RUN_ID');" >> "$ORCH_FILE"
echo "  Object.keys(maxModules).forEach(k => {" >> "$ORCH_FILE"
echo "    console.log('Running module:', k);" >> "$ORCH_FILE"
echo "  });" >> "$ORCH_FILE"
echo "};" >> "$ORCH_FILE"

# 3. METADATA EXPANSION
META_FILE="core/generated/metadata.json"
echo "{" > "$META_FILE"
echo "  \"name\": \"max-git-system\"," >> "$META_FILE"
echo "  \"version\": \"4.0.0\"," >> "$META_FILE"
echo "  \"runId\": \"$RUN_ID\"," >> "$META_FILE"
echo "  \"timestamp\": \"$(date -u +"%Y-%m-%dT%H:%M:%SZ")\"," >> "$META_FILE"
echo "  \"moduleCount\": $(ls core/modules/*.ts | wc -l)" >> "$META_FILE"
echo "}" >> "$META_FILE"

# 4. SESSION LOGGER
LOG_FILE="$RUN_DIR/run-log.json"
echo "{" > "$LOG_FILE"
echo "  \"runId\": \"$RUN_ID\"," >> "$LOG_FILE"
echo "  \"timestamp\": \"$(date -u +"%Y-%m-%dT%H:%M:%SZ")\"," >> "$LOG_FILE"
echo "  \"status\": \"completed\"" >> "$LOG_FILE"
echo "}" >> "$LOG_FILE"

# 5. RUN FOLDER CREATOR
touch "$RUN_DIR/placeholder.txt"

# 6. DOCS GENERATOR
DOC_FILE="core/generated/docs.md"
echo "# MAX Git System Documentation" > "$DOC_FILE"
echo "Generated on: $(date -u +"%Y-%m-%dT%H:%M:%SZ")" >> "$DOC_FILE"
echo "" >> "$DOC_FILE"
echo "## Modules" >> "$DOC_FILE"
for f in core/modules/*.ts; do
  NAME=$(basename "$f")
  echo "- $NAME" >> "$DOC_FILE"
done
echo "" >> "$DOC_FILE"
echo "## Run ID" >> "$DOC_FILE"
echo "$RUN_ID" >> "$DOC_FILE"

# 7. SUMMARY GENERATOR (NEW FOR V4)
SUMMARY_FILE="core/generated/summary.json"
echo "{" > "$SUMMARY_FILE"
echo "  \"runId\": \"$RUN_ID\"," >> "$SUMMARY_FILE"
echo "  \"timestamp\": \"$(date -u +"%Y-%m-%dT%H:%M:%SZ")\"," >> "$SUMMARY_FILE"
echo "  \"modules\": [" >> "$SUMMARY_FILE"

FIRST=true
for f in core/modules/*.ts; do
  NAME=$(basename "$f" .ts)
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    echo "    ," >> "$SUMMARY_FILE"
  fi
  echo "    \"$NAME\"" >> "$SUMMARY_FILE"
done

echo "  ]," >> "$SUMMARY_FILE"
echo "  \"docs\": \"core/generated/docs.md\"," >> "$SUMMARY_FILE"
echo "  \"metadata\": \"core/generated/metadata.json\"," >> "$SUMMARY_FILE"
echo "  \"runLog\": \"$RUN_DIR/run-log.json\"" >> "$SUMMARY_FILE"
echo "}" >> "$SUMMARY_FILE"

# AUTO COMMIT
git config user.name "github-actions"
git config user.email "github-actions@github.com"

git add .
git commit -m "Auto-build v4: $RUN_ID" || true
