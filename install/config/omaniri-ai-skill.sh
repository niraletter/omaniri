# Place in each assistant's global skills directory so the omaniri skill is available on first install
mkdir -p ~/.agents/skills ~/.claude/skills ~/.codex/skills ~/.pi/agent/skills
ln -sfn "$OMANIRI_PATH/default/omaniri-skill" ~/.agents/skills/omaniri
ln -sfn "$OMANIRI_PATH/default/omaniri-skill" ~/.claude/skills/omaniri
ln -sfn "$OMANIRI_PATH/default/omaniri-skill" ~/.codex/skills/omaniri
ln -sfn "$OMANIRI_PATH/default/omaniri-skill" ~/.pi/agent/skills/omaniri
