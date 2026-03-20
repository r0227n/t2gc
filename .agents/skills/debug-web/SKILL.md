---
name: debug-web
description: Run a local Flutter app on the `web-server` device and inspect it with `agent-browser` CLI to reproduce bugs, verify fixes, capture screenshots, and collect console or page errors. Use when Codex needs to confirm Flutter Web behavior in this workspace, debug a localhost flow, validate a browser regression, or inspect a user-reported issue in the app UI.
---

# Debug Web

## Overview

Build and serve the workspace app as Flutter Web, drive it with
`agent-browser`, and collect browser evidence before changing code or
reporting results.

Prefer this skill when the target is the local app, not an external website.
For raw browser automation details, also read
`/Users/r0227n/Dev/t2gc/.agents/skills/agent-browser/SKILL.md`.

## Standard Workflow

1. Start the app from the repository root in a dedicated PTY session and keep
   that session open while testing.

   ```bash
   ./.agents/skills/debug-web/scripts/run_flutter_web.sh \
     serve \
     --project-root "$PWD"
   ```

   The script builds Flutter Web, starts a local HTTP server, and prints
   `APP_URL` plus `LOG_FILE`.

2. Open the app with `agent-browser` and wait for the first paint.

   ```bash
   agent-browser open http://127.0.0.1:7357
   agent-browser wait 2000
   agent-browser snapshot -i
   ```

3. Reproduce the flow.

   - Re-run `agent-browser snapshot -i` after each navigation or major DOM
     update.
   - Prefer element refs like `@e1` from `snapshot -i`.
   - Use `agent-browser --headed ...` when a visual browser helps.

4. Collect evidence before concluding.

   ```bash
   agent-browser screenshot
   agent-browser console
   agent-browser errors
   agent-browser network requests
   ```

5. Stop the server when done.

   ```bash
   # End the PTY session or press Ctrl+C in the serve session.
   ```

## Debugging Rules

- Prefer a locally served web build over `flutter run -d chrome` so
  `agent-browser` owns the browser session.
- Keep the port fixed unless there is a conflict. The default is `7357`.
- Read the Flutter run log first if the page never loads.
- Verify both browser-side evidence and terminal-side evidence before assuming
  the bug is in Flutter widgets.
- Report exact reproduction steps, observed result, expected result, and the
  strongest evidence you found.

## First Commands to Reach For

```bash
# Start app
./.agents/skills/debug-web/scripts/run_flutter_web.sh serve --project-root "$PWD"

# Open and inspect
agent-browser open http://127.0.0.1:7357
agent-browser snapshot -i
agent-browser screenshot
agent-browser console
agent-browser errors

# Shut down
# End the serve session with Ctrl+C
```

## Troubleshooting

- If `agent-browser open` fails because the browser is not installed, run
  `agent-browser install` once.
- If the app build or local server setup fails, inspect the log file printed by
  `run_flutter_web.sh`.
- In Codex, prefer `serve` over `start`. Detached background processes are often
  cleaned up when the command finishes.
- If the DOM looks empty, wait a bit longer, then take another snapshot.
- If a port is already occupied, re-run the script with `--port <port>`.

Read
`/Users/r0227n/Dev/t2gc/.agents/skills/debug-web/references/workflow.md`
when you need a fuller checklist or example command sequences.
