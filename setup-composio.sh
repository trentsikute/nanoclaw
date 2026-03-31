#!/bin/bash
# NanoClaw — Composio MCP Integration Setup
# Rebuilds NanoClaw with Composio MCP support and restarts.
# Prerequisites: Composio MCP URL in .env, API key in OneCLI.
# Usage: bash setup-composio.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

ok()   { echo -e "${GREEN}✓ $1${NC}"; }
warn() { echo -e "${YELLOW}⚠ $1${NC}"; }
fail() { echo -e "${RED}✗ $1${NC}"; exit 1; }
info() { echo -e "${CYAN}→ $1${NC}"; }

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║   NanoClaw — Composio MCP Setup          ║"
echo "╚══════════════════════════════════════════╝"
echo ""

# ── Step 1: Verify .env has MCP URL ─────────────────────────────────────────
info "Step 1: Checking .env for COMPOSIO_MCP_URL..."
if grep -q 'COMPOSIO_MCP_URL' .env 2>/dev/null; then
  ok "COMPOSIO_MCP_URL found in .env"
else
  fail "COMPOSIO_MCP_URL not found in .env — add it first"
fi

# ── Step 2: Verify OneCLI secret ────────────────────────────────────────────
info "Step 2: Checking OneCLI for Composio secret..."
echo "  Verify at http://127.0.0.1:10254/secrets that 'Composio' exists with:"
echo "    Host: *.composio.dev"
echo "    Header: x-api-key"
echo ""
echo -n "  Press Enter to continue..."
read -r
ok "OneCLI secret confirmed"

# ── Step 3: Build TypeScript ────────────────────────────────────────────────
info "Step 3: Building NanoClaw..."
npm run build
ok "TypeScript compiled"

# ── Step 4: Rebuild container ───────────────────────────────────────────────
info "Step 4: Rebuilding container image..."
cd container
container build -t nanoclaw-agent:latest .
cd "$SCRIPT_DIR"
ok "Container rebuilt"

# ── Step 5: Clear cached agent-runner source ────────────────────────────────
info "Step 5: Clearing cached agent-runner source..."
# The agent-runner is copied per-group; clear the cache so the new
# version (with Composio MCP config) is picked up on next invocation.
find data/sessions -name 'agent-runner-src' -type d -exec rm -rf {} + 2>/dev/null || true
ok "Agent-runner cache cleared"

# ── Step 6: Restart service ─────────────────────────────────────────────────
info "Step 6: Restarting NanoClaw service..."
if launchctl list | grep -q "com.nanoclaw" 2>/dev/null; then
  launchctl kickstart -k "gui/$(id -u)/com.nanoclaw"
  ok "Service restarted"
else
  warn "Service not found in launchctl — start manually: npm run dev"
fi

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║   Composio MCP integration ready! 🔗     ║"
echo "║                                          ║"
echo "║   Connect apps at app.composio.dev       ║"
echo "║   Test: ask NanoClaw to check your inbox ║"
echo "╚══════════════════════════════════════════╝"
echo ""
