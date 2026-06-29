#!/bin/bash
# Mission Driven AI Spellbook — installer
# Usage: curl -sSL https://raw.githubusercontent.com/andersthemagi/mission-driven-ai-spellbook/main/install.sh | bash
# Or install a single skill: ... | bash -s -- mission-check

set -e

REPO="https://github.com/andersthemagi/mission-driven-ai-spellbook"
SKILLS_DIR="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
ALL_SKILLS="long-run mission-check prompt-brief rao-ready ship-check ship-plan"

# create skills dir if it doesn't exist
mkdir -p "$SKILLS_DIR"

# clone to temp dir
TMP=$(mktemp -d)
trap "rm -rf $TMP" EXIT
git clone --quiet "$REPO" "$TMP/spellbook"

if [ -n "$1" ]; then
  # install a single named skill
  SKILL="$1"
  if [ ! -d "$TMP/spellbook/$SKILL" ]; then
    echo "Unknown skill: $SKILL"
    echo "Available: $ALL_SKILLS"
    exit 1
  fi
  cp -r "$TMP/spellbook/$SKILL" "$SKILLS_DIR/"
  echo "Installed /$SKILL to $SKILLS_DIR/$SKILL"
else
  # install all skills
  for skill in $ALL_SKILLS; do
    cp -r "$TMP/spellbook/$skill" "$SKILLS_DIR/"
    echo "Installed /$skill"
  done
  echo ""
  echo "Mission Driven AI Spellbook installed to $SKILLS_DIR"
  echo "Invoke any skill with /skill-name in Claude Code."
fi
