# Mattermost database diagrams (by domain)

Split ER diagrams from `../final.sql` for readable PNG/SVG export. Each file focuses on one area.

**Diagram convention:** Each entity shows a **subset** of columns — primary keys (PK), foreign keys (FK), and other important fields. The **authoritative schema is `../final.sql`**; diagrams omit some columns (e.g. long text, jsonb, or rarely-used fields) to stay readable. If a column exists in `final.sql` but not in a diagram, it is intentional omission, not an error. Critical fields like `posts.fileids` are included.

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

Single diagram (default 800×600, often low resolution):

```bash
npx -p @mermaid-js/mermaid-cli mmdc -i mattermost/sql/diagrams/01-core-users-teams-channels.mmd -o mattermost/sql/diagrams/01-core-users-teams-channels.png
```

### High-resolution PNG

Use a larger **width** (`-w`) and **scale** (`-s`) so the image is sharp (e.g. for print or retina):

```bash
npx -p @mermaid-js/mermaid-cli mmdc -i mattermost/sql/diagrams/01-core-users-teams-channels.mmd -o mattermost/sql/diagrams/01-core-users-teams-channels.png -w 2400 -s 2
```

- **`-w 2400`** — viewport width in pixels (default 800). Use 2400–4000 for big diagrams.
- **`-s 2`** — scale factor (default 1). Use 2 for 2× pixel density (sharp on retina).
- **`-H 1800`** — optional height if the diagram is tall; increase if the bottom is clipped.

**Export all diagrams at high resolution** (from repo root):

```bash
for f in mattermost/sql/diagrams/*.mmd; do
  npx -p @mermaid-js/mermaid-cli mmdc -i "$f" -o "${f%.mmd}.png" -w 2400 -s 2
done
```

**SVG** stays sharp at any size; use it when you need to zoom or print:

```bash
npx -p @mermaid-js/mermaid-cli mmdc -i mattermost/sql/diagrams/01-core-users-teams-channels.mmd -o mattermost/sql/diagrams/01-core-users-teams-channels.svg
```

Or use [Mermaid Live Editor](https://mermaid.live): paste each `.mmd` file and export as PNG/SVG (use the zoom/scale in the editor before export for higher-res PNG).
