#!/usr/bin/env bash

# Find all AGENTS.md files in current directory and subdirectories
# This is a temporary solution for the case where Claude Code is not satisfied with the AGENTS.md usage.
# See: https://github.com/anthropics/claude-code/issues/6235

set -euo pipefail

if [ -z "$CLAUDE_PROJECT_DIR" ]; then
  echo "Error: CLAUDE_PROJECT_DIR is not set. Cannot search for AGENTS.md files." >&2
  exit 1
fi

cd "$CLAUDE_PROJECT_DIR" || { echo "Error: Failed to change directory to $CLAUDE_PROJECT_DIR" >&2; exit 1; }

# Check project wide AGENTS.md files.
# Sort by path length (ascending) - from general to specific.
# Shorter paths = closer to root = lower precedence.
AGENTSMD_FILES=$(find "${CLAUDE_PROJECT_DIR}" \
  ! -path "*/node_modules/*" \
  ! -path "*/.git/*" \
  ! -path "*/vendor/*" \
  ! -path "*/.venv/*" \
  -name "AGENTS.md" \
  -type f | awk '{ print length, $0 }' | sort -n | cut -d' ' -f2-)

if [ -f "$HOME/AGENTS.md" ]; then
  if [ -n "$AGENTSMD_FILES" ]; then
    AGENTSMD_FILES="$HOME/AGENTS.md
$AGENTSMD_FILES"
  else
    AGENTSMD_FILES="$HOME/AGENTS.md"
  fi
fi

# Exit if no AGENTS.md files found
[ -z "$AGENTSMD_FILES" ] && exit 0

cat <<end_context
<agentsmd_instructions>
This project uses AGENTS.md files to provide scoped instructions based on the
file or directory being worked on.

This project has the following AGENTS.md files:
<available_agentsmd_files>
$AGENTSMD_FILES
</available_agentsmd_files>

NON-NEGOTIABLE: When working with any file or directory within the project:

1. Load ALL AGENTS.md files in the directory hierarchy matching that location
   BEFORE you start working on (reading/writing/etc) the file or directory. You
   do not have to reload AGENTS.md files you have already loaded previously.

2. ALWAYS apply instructions from the AGENTS.md files that match that location.
   When there are conflicting instructions, apply instructions from the
   AGENTS.md file that is CLOSEST (most specific) to that location. More
   specific instructions OVERRIDE more general ones.

   Precedence order (from lowest to highest priority):
   - Global AGENTS.md (~/AGENTS.md) - lowest priority
   - Project root AGENTS.md (./AGENTS.md)
   - Nested AGENTS.md files - highest priority (closest to the file)

   <example>
     Project structure:
       ~/AGENTS.md               (global, user home directory)
       ./AGENTS.md               (project root)
       subfolder/
         file.txt
         AGENTS.md               (nested)

     When working with "subfolder/file.txt":
       - Instructions from "subfolder/AGENTS.md" take highest precedence
       - Instructions from "./AGENTS.md" override global
       - Instructions from "~/AGENTS.md" apply only if not overridden
   </example>

3. If there is a root ./AGENTS.md file, ALWAYS apply its instructions to ALL
   work within the project, as everything you do is within scope of the project.
   Precedence rules still apply for conflicting instructions.
</agentsmd_instructions>
end_context

# Load global AGENTS.md first (lowest precedence)
if [ -f "$HOME/AGENTS.md" ]; then
cat <<end_global_context

The content of ~/AGENTS.md is as follows:

<agentsmd path="~/AGENTS.md" absolute_path="$HOME/AGENTS.md">
$(cat "$HOME/AGENTS.md")
</agentsmd>
end_global_context
fi

# If there is a root AGENTS.md, load it now (higher precedence than global)
if [ -f "./AGENTS.md" ]; then
cat <<end_root_context

The content of ./AGENTS.md is as follows:

<agentsmd path="./AGENTS.md" absolute_path="$CLAUDE_PROJECT_DIR/AGENTS.md">
$(cat "./AGENTS.md")
</agentsmd>
end_root_context
fi
