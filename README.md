 # 🧙‍♂️ Wizards DevOps Mentorship

> Setup guide for cloning and getting started with the mentorship vault

---

## Getting Started (First Time Setup)

### For New Users - Clone & Setup

1. **Clone the Repository**
   ```bash
   git clone <repository-url>
   cd Mentorship
   ```

2. **Run the Setup Script**
   ```bash
   bash init.sh
   ```
   This copies the shared config (`.obsidian-config/`) to your local `.obsidian/` folder.

3. **Open in Obsidian**
   - Open Obsidian
   - Click "Open folder as vault"
   - Navigate to the cloned `Mentorship` folder
   - Click "Open"
   - Click "Trust author and enable plugins" (this vault uses verified, safe plugins)
   - Restart Obsidian for all plugins to load properly


4. **You're Ready!**
   - The vault will open to the Home page automatically
   - **Wizards:** Navigate to your personal Grimoire from the Home page

---

## Troubleshooting

**Plugins not working?**
- Go to Settings → Community Plugins
- Make sure "Trust author and enable plugins" is enabled
- Verify these core plugins are enabled:
  - **Dataview** (required for dashboards)
  - **Templater** (required for creating weeks)
  - **Meta Bind** (required for interactive buttons)
  - **Homepage** (required for auto-opening Home page)

**Dashboard not showing data?**
- Wait a few seconds for Dataview to load
- Check that inline DataviewJS is enabled in Dataview settings

**Can't find a file?**
- Use `Cmd/Ctrl + O` for quick switcher
- Check the Home page for navigation links

**Note about Git and .obsidian settings:**
- Your personal Obsidian settings (in `.obsidian/`) are automatically ignored by Git
- You can customize plugins, appearance, and hotkeys without affecting the shared repository
- Only commit changes to your Grimoire and notes in the `Wizards/` folder

**Re-running setup after config updates:**
- If the shared config (`.obsidian-config/`) is updated, run `bash init.sh` again to get the latest settings
- The script will back up your existing `.obsidian/` before overwriting

