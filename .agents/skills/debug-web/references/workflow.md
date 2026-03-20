# Debug Web Workflow

## Checklist

1. Build and start the local app with
   `./.agents/skills/debug-web/scripts/run_flutter_web.sh serve --project-root "$PWD"`.
2. Open `APP_URL` with `agent-browser`.
3. Wait for initial rendering.
4. Capture `snapshot -i`, `screenshot`, `console`, and `errors`.
5. Reproduce the exact user flow.
6. Capture evidence again after the failure or success state.
7. Stop the local server by ending the `serve` session with `Ctrl+C`.

## Typical Commands

```bash
agent-browser open http://127.0.0.1:7357
agent-browser wait 2000
agent-browser snapshot -i
agent-browser click @e1
agent-browser fill @e2 "example"
agent-browser screenshot
agent-browser console
agent-browser errors
```

## What to Check

- Wrong route, redirect, or query parameter handling
- Missing text, broken layout, or invisible controls
- JavaScript exceptions or Flutter bootstrap failures
- Unexpected network requests or failed API calls
- State restoration issues after reload

## When Headed Mode Helps

Use `agent-browser --headed ...` when hover state, focus state, animation timing,
or modal layering is relevant and headless output is not enough.

## Reporting Template

- Reproduction steps:
- Expected result:
- Observed result:
- Browser evidence:
- Flutter log evidence:
- Most likely layer involved:
