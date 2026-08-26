#!/usr/bin/env bash
# Thin wrapper around export_approved_questions.py, per the approved Faz D
# invocation shape: scripts/export-approved-questions.sh 101 102 103
#
# See scripts/export_approved_questions.py for the full behavior/contract
# (dev-only, explicit-batch-only, never touches production).
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec python3 "$SCRIPT_DIR/export_approved_questions.py" "$@"
