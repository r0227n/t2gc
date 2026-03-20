#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  run_flutter_web.sh [serve] [options]
  run_flutter_web.sh start [options]
  run_flutter_web.sh stop [options]
  run_flutter_web.sh status [options]

Options:
  --project-root PATH   Repository root. Defaults to current directory.
  --app-dir PATH        Flutter app directory. Defaults to <project-root>/app.
  --port PORT           Web server port. Defaults to 7357.
  --mode MODE           debug, profile, or release. Defaults to release.
  --timeout SEC         Startup timeout in seconds. Defaults to 180.
  --no-pub-get          Skip `flutter pub get` before launch.
  --help                Show this message.
EOF
}

action="serve"
project_root="$(pwd)"
app_dir=""
port="7357"
mode="release"
timeout_sec="180"
run_pub_get="1"

if [[ "${1:-}" != "" && "${1:-}" != --* ]]; then
  action="$1"
  shift
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project-root)
      project_root="$2"
      shift 2
      ;;
    --app-dir)
      app_dir="$2"
      shift 2
      ;;
    --port)
      port="$2"
      shift 2
      ;;
    --mode)
      mode="$2"
      shift 2
      ;;
    --timeout)
      timeout_sec="$2"
      shift 2
      ;;
    --no-pub-get)
      run_pub_get="0"
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [[ -z "$app_dir" ]]; then
  app_dir="$project_root/app"
fi

project_root="$(cd "$project_root" && pwd)"
app_dir="$(cd "$app_dir" && pwd)"
runtime_dir="$project_root/.dart_tool/debug-web"
pid_file="$runtime_dir/flutter-web-$port.pid"
log_file="$runtime_dir/flutter-web-$port.log"
url="http://127.0.0.1:$port"

mkdir -p "$runtime_dir"

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

print_state() {
  echo "APP_URL=$url"
  echo "LOG_FILE=$log_file"
  echo "PID_FILE=$pid_file"
}

running_pid() {
  if [[ ! -f "$pid_file" ]]; then
    return 1
  fi

  local pid
  pid="$(cat "$pid_file")"
  [[ -n "$pid" ]] || return 1
  kill -0 "$pid" >/dev/null 2>&1
}

stop_port_process() {
  local pids
  pids="$(lsof -ti "tcp:$port" 2>/dev/null || true)"
  if [[ -z "$pids" ]]; then
    return 0
  fi

  while IFS= read -r pid; do
    [[ -n "$pid" ]] || continue
    kill "$pid" >/dev/null 2>&1 || true
  done <<<"$pids"
}

wait_until_ready() {
  local start_ts
  start_ts="$(date +%s)"

  while true; do
    if curl -fsS "$url" >/dev/null 2>&1; then
      return 0
    fi

    if ! running_pid; then
      echo "Local web server exited before the app became reachable." >&2
      return 1
    fi

    if (( "$(date +%s)" - start_ts >= timeout_sec )); then
      echo "Timed out waiting for $url" >&2
      return 1
    fi

    sleep 1
  done
}

build_web() {
  require_command flutter
  require_command curl
  require_command lsof
  require_command python3

  if [[ ! -f "$app_dir/pubspec.yaml" ]]; then
    echo "Flutter app directory not found: $app_dir" >&2
    exit 1
  fi

  if [[ "$run_pub_get" == "1" ]]; then
    (
      cd "$app_dir"
      flutter pub get >/dev/null
    )
  fi

  local flutter_mode_flag="--release"
  case "$mode" in
    debug)
      flutter_mode_flag="--debug"
      ;;
    profile)
      flutter_mode_flag="--profile"
      ;;
    release)
      ;;
    *)
      echo "Unsupported mode: $mode" >&2
      exit 1
      ;;
  esac

  : >"$log_file"
  if ! (
    cd "$app_dir"
    flutter build web "$flutter_mode_flag" >>"$log_file" 2>&1
  ); then
    echo "Flutter web build failed." >&2
    echo "LOG_FILE=$log_file" >&2
    tail -n 60 "$log_file" >&2 || true
    exit 1
  fi
}

start_server() {
  if running_pid; then
    echo "Flutter web server is already running."
    print_state
    return 0
  fi

  stop_port_process
  rm -f "$pid_file"
  build_web
  (
    cd "$app_dir/build/web"
    nohup python3 -m http.server "$port" \
      --bind 127.0.0.1 \
      >>"$log_file" 2>&1 &
    echo "$!" >"$pid_file"
  )

  if ! wait_until_ready; then
    tail -n 40 "$log_file" >&2 || true
    exit 1
  fi

  echo "Flutter web server started."
  print_state
}

serve_foreground() {
  if lsof -ti "tcp:$port" >/dev/null 2>&1; then
    echo "Port $port is already in use." >&2
    exit 1
  fi

  build_web
  echo "Flutter web server started."
  print_state
  cd "$app_dir/build/web"
  exec python3 -m http.server "$port" --bind 127.0.0.1
}

stop_server() {
  if running_pid; then
    local pid
    pid="$(cat "$pid_file")"
    kill "$pid" >/dev/null 2>&1 || true
    for _ in $(seq 1 20); do
      if ! kill -0 "$pid" >/dev/null 2>&1; then
        break
      fi
      sleep 1
    done
    if kill -0 "$pid" >/dev/null 2>&1; then
      kill -9 "$pid" >/dev/null 2>&1 || true
    fi
  fi

  stop_port_process
  rm -f "$pid_file"
  echo "Flutter web server stopped."
  print_state
}

status_server() {
  if running_pid; then
    echo "STATUS=running"
  else
    echo "STATUS=stopped"
  fi
  print_state
}

case "$action" in
  serve)
    serve_foreground
    ;;
  start)
    start_server
    ;;
  stop)
    stop_server
    ;;
  status)
    status_server
    ;;
  *)
    echo "Unknown action: $action" >&2
    usage >&2
    exit 1
    ;;
esac
