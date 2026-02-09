# Mattermost database diagrams (by domain)

Split ER diagrams from `../final.sql` for readable PNG/SVG export. Each file focuses on one area.

| File | Description |
|------|-------------|
| **01-core-users-teams-channels.mmd** | Users, teams, schemes, channels, channel/team members, channel member history, public channels |
| **02-posts-content.mmd** | Posts, file info, reactions, threads, thread memberships, read receipts, scheduled posts, upload sessions |
| **03-auth-sessions.mmd** | Sessions, audits, bots, OAuth apps/access, user access tokens, terms of service |
| **04-webhooks-commands.mmd** | Commands, command webhooks, incoming/outgoing webhooks |
| **05-groups.mmd** | User groups, group members, group–channel and group–team links |
| **06-preferences-sidebar.mmd** | User preferences, status, sidebar categories and channels |
| **07-recaps-retention-shared.mmd** | Recaps, retention policies, shared channels, remote clusters |
| **08-misc.mmd** | Jobs, emoji, compliances, licenses, systems, link metadata, content flagging, plugins, translations, notices, recent searches, cluster discovery |

## Export to PNG

Single diagram:

```bash
npx -p @mermaid-js/mermaid-cli mmdc -i mattermost/sql/diagrams/01-core-users-teams-channels.mmd -o mattermost/sql/diagrams/01-core-users-teams-channels.png
```

All diagrams (from repo root):

```bash
for f in mattermost/sql/diagrams/*.mmd; do
  npx -p @mermaid-js/mermaid-cli mmdc -i "$f" -o "${f%.mmd}.png"
done
```

Or use [Mermaid Live Editor](https://mermaid.live): paste each `.mmd` file and export as PNG/SVG.
