#!/bin/bash

# Find all AGENTS.md files in current directory and subdirectories
# This is a temporary solution for the case where Claude Code is not satisfied with the AGENTS.md usage.
# See: https://github.com/anthropics/claude-code/issues/6235


if [ -z "${CLAUDE_PROJECT_DIR}" ]; then
  echo "Error: CLAUDE_PROJECT_DIR is not set" >&2
  exit 1
fi


echo "=== AGENTS.md Files Found ==="
find "$CLAUDE_PROJECT_DIR" -name "AGENTS.md" -type f | while read -r file; do
  echo "--- File: $file ---"
  if ! cat "$file"; then
    echo "Error: Failed to read file: $file" >&2
    continue
  fi
  echo ""
done

# Check the exit status of the find command in the pipeline
find_exit_status=${PIPESTATUS[0]}
if [ "$find_exit_status" -ne 0 ]; then
  echo "Error: find command failed with exit status ${find_exit_status}" >&2
  exit "$find_exit_status"
fi
