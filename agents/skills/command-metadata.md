# Command Metadata

Read this before adding or changing commands in `bin/`.

Commands in `bin/` can declare CLI metadata in comments near the top of the
file. `bin/omaniri` scans the first 80 lines, and tests expect command metadata
to remain valid.

Supported metadata keys:

- `# omaniri:group=...` - override the command group inferred from the filename
- `# omaniri:name=...` - override the command name inferred from the filename
- `# omaniri:summary=...` - short help text
- `# omaniri:args=...` - usage arguments
- `# omaniri:examples=...` - examples separated with ` | `
- `# omaniri:alias=...` / `# omaniri:aliases=...` - alternate routes
- `# omaniri:hidden=true` - hide from default command listings
- `# omaniri:requires-sudo=true` - mark commands that require sudo

Only use `omaniri:examples` where there are args that need explaining.

Prefer explicit metadata for user-facing commands. Keep routes consistent with
the filename unless there is a deliberate alias or compatibility route.

Example:

```bash
# omaniri:summary=Take a screenshot
# omaniri:args=[smart|region|windows|fullscreen] [slurp|copy]
# omaniri:examples=omaniri screenshot | omaniri capture screenshot region
```
