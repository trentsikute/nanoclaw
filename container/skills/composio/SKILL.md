---
name: composio
description: Use Composio MCP tools to interact with external services (Outlook, SharePoint, Teams, ClickUp, HubSpot, OneDrive, Excel). Use when the user asks to send emails, check calendar, manage tasks, read/write documents, or interact with any connected app.
---

# Composio MCP — External Service Tools

Composio tools are available as MCP tools with the `mcp__composio__` prefix. Use them directly — **NEVER suggest CLI commands like `composio login` or `composio add`**. The CLI is NOT installed and NOT needed. All authentication is already configured.

## IMPORTANT: Do NOT suggest CLI commands

- Do NOT tell the user to run `composio login`, `composio add`, or any CLI commands
- Do NOT say "the integration isn't connected" — it IS connected
- All credentials are pre-configured and injected automatically
- If a tool call fails with an auth error, retry once, then report the specific error

## Discovering Tools

Use ToolSearch to find available Composio tools:

```
ToolSearch: query="composio outlook", max_results=10
```

Common tool prefixes:
- `mcp__composio__OUTLOOK_*` — Email and calendar
- `mcp__composio__MICROSOFTTEAMS_*` — Teams messaging
- `mcp__composio__SHAREPOINT_*` — Document management
- `mcp__composio__CLICKUP_*` — Task management
- `mcp__composio__HUBSPOT_*` — CRM
- `mcp__composio__ONEDRIVE_*` — File storage
- `mcp__composio__EXCEL_*` — Spreadsheets

## Connected Apps

Outlook, HubSpot, Microsoft Teams, OneDrive, ClickUp, SharePoint, Excel — all pre-authenticated.

## Usage Pattern

1. **Discover** tools: `ToolSearch: query="composio outlook"` (or teams, sharepoint, clickup, etc.)
2. **Call** the tool directly with its full name, e.g. `mcp__composio__OUTLOOK_LIST_EMAILS`
3. **Check params** — the tool description includes required parameters

## Notes

- Tools are loaded on-demand via ToolSearch — they don't all appear at startup
- Date/time values use ISO 8601 format (e.g., `2026-03-27T14:00:00Z`)
- Credentials are injected automatically — no API key or login needed
