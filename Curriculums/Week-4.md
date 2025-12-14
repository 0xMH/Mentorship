---
week: 4
topic: Linux Fundamentals & The Terminal
share_link:
share_updated:
---
# Linux: Where DevOps Actually Lives

> **The terminal isn't scary. It's your superpower.**

Here's the thing about servers. They don't have fancy GUIs with buttons and icons. No drag-and-drop. No "right-click, delete." Just a blinking cursor waiting for you to tell it what to do.

And in the server world, Linux dominates. We're talking about 90%+ of all servers running some flavor of Linux. AWS, Azure, GCP, your company's production environment, that random VPS you spun up to learn Docker. All Linux.

So if you're getting into DevOps without learning Linux, you're trying to be a chef who doesn't know how to use a knife.

### Why Linux?

**The honest answer:** Because that's what runs everything.

- Most cloud servers run Linux
- Docker containers are Linux-based
- Kubernetes nodes are (mostly) Linux
- CI/CD pipelines run on Linux
- Even MacOS is Unix-based (close enough)

**The practical answer:** It's free, it's powerful, and once you get it, you _get_ it.

Windows Server exists. Some companies use it. But in the DevOps world, Linux is the default. The sooner you embrace that, the better.

---

## The Two Linux Families

Linux isn't one thing. It's a kernel (the core) with hundreds of distributions built on top. But don't let that overwhelm you. For practical purposes, there are two main families:

### Debian/Ubuntu Family
- **Ubuntu** (most popular for beginners and servers)
- Debian (Ubuntu's parent, more stable, less frequent updates)
- Linux Mint (desktop-focused)

**Package manager:** `apt`
```bash
sudo apt update
sudo apt install nginx
```

### Red Hat/CentOS Family
- **Red Hat Enterprise Linux (RHEL)** (enterprise, paid support)
- CentOS / Rocky Linux / AlmaLinux (free RHEL alternatives)
- Fedora (cutting-edge, used for testing new features)

**Package manager:** `yum` or `dnf`
```bash
sudo dnf update
sudo dnf install nginx
```

**Which one should you pick?**

Start with **Ubuntu**. Here's why:
- Huge community, tons of tutorials
- Most beginner-friendly
- Very common in production environments
- If something breaks, someone on Stack Overflow already fixed it

Once you're comfortable, the skills transfer. Learning `apt` vs `dnf` is like learning British vs American English. Different words, same language.

---

## The Terminal Is Your Friend

Let's address the elephant in the room. The terminal looks intimidating. A black screen with white text feels like something from the 90s. Why would anyone use this when GUIs exist?

**The GUI approach:**
```
Click folder → Click folder → Click folder → Right-click → New file → Type name → Click save
```

**The terminal approach:**
```bash
touch /path/to/new/file.txt
```

One line. Done.

**Here's what the terminal gives you:**
- Speed (once you know the commands)
- Automation (scripts can run commands, not clicks)
- Remote access (SSH into a server, no GUI needed)
- Power (some things literally can't be done in a GUI)

The GUI is your bicycle training wheels. Helpful at first, but eventually you need to take them off.

---

## Linux Directory Structure

Windows has `C:\Users\YourName\Documents`. Linux has... something different.

Everything in Linux starts from `/` (called "root", not to be confused with the root user). Here's what matters:

```
/
├── home/          # User home directories (/home/yourname)
├── etc/           # Configuration files (think "settings")
├── var/           # Variable data (logs, databases, websites)
│   ├── log/       # System and application logs
│   └── www/       # Web server files (sometimes)
├── usr/           # User programs and utilities
│   ├── bin/       # Common executables
│   └── local/     # Locally installed software
├── tmp/           # Temporary files (cleared on reboot)
├── opt/           # Optional/third-party software
└── root/          # Root user's home directory (not /home/root)
```

**The ones you'll use most:**
- `/home/yourname` or `~` (your stuff)
- `/etc` (config files for everything)
- `/var/log` (when things break, check here)
- `/tmp` (need a scratch space? use this)

**Key insight:** In Linux, _everything_ is a file. Devices, processes, configurations. Everything. This sounds weird until it clicks, and then it's beautiful.

---

## Permissions: Who Can Do What

Linux is paranoid about permissions. And that's a good thing.

Every file and directory has three permission types:
- **Read (r):** Can you see the contents?
- **Write (w):** Can you modify it?
- **Execute (x):** Can you run it (for scripts/programs)?

And three user categories:
- **Owner:** The user who owns the file
- **Group:** Users in the file's group
- **Others:** Everyone else

When you run `ls -l`, you see something like:
```bash
-rwxr-xr-- 1 ahmed developers 4096 Dec 14 10:30 script.sh
```

Let's break that down:
```
-rwxr-xr--
│├─┤├─┤├─┤
│ │  │  └── Others: read only (r--)
│ │  └───── Group: read + execute (r-x)
│ └──────── Owner: read + write + execute (rwx)
└────────── File type (- = file, d = directory)
```

**Changing permissions:**
```bash
chmod 755 script.sh    # Owner: rwx, Group: r-x, Others: r-x
chmod +x script.sh     # Add execute permission
chmod u+w file.txt     # Add write permission for owner
```

**Changing ownership:**
```bash
chown ahmed:developers file.txt    # Change owner and group
chown ahmed file.txt               # Change owner only
```

**The 777 trap:**
```bash
chmod 777 everything    # NEVER do this in production
```

`777` means everyone can read, write, and execute. It's the "I give up on security" permission. You'll see tutorials suggesting it to "fix" permission issues. Don't. Fix the actual problem instead.

---

## Essential Commands You Need to Know

You don't need to memorize every Linux command. That's what `man` pages and Google are for. But these are your bread and butter:

### Navigation
```bash
pwd                    # Where am I? (Print Working Directory)
ls                     # What's here?
ls -la                 # What's here? (detailed, including hidden)
cd /path/to/somewhere  # Go somewhere
cd ~                   # Go home
cd ..                  # Go up one level
cd -                   # Go back to previous directory
```

### File Operations
```bash
touch file.txt         # Create empty file
mkdir folder           # Create directory
mkdir -p a/b/c         # Create nested directories
cp file.txt backup.txt # Copy file
cp -r folder/ backup/  # Copy directory (recursive)
mv old.txt new.txt     # Rename/move file
rm file.txt            # Delete file (no trash, it's gone)
rm -r folder/          # Delete directory (careful!)
rm -rf folder/         # Force delete (very careful!)
```

**Real talk:** `rm -rf` is powerful. Too powerful. There's no "are you sure?" and no recycle bin. Double-check your path before hitting enter.

![[Attachments/rm-rf-meme.png]]

### Reading Files
```bash
cat file.txt           # Print entire file
less file.txt          # View file with scrolling (q to quit)
head file.txt          # First 10 lines
head -n 20 file.txt    # First 20 lines
tail file.txt          # Last 10 lines
tail -f log.txt        # Follow file (live updates, great for logs)
```

### Searching
```bash
grep "error" log.txt           # Find lines containing "error"
grep -r "TODO" ./              # Search recursively in directory
grep -i "error" log.txt        # Case-insensitive search
find . -name "*.log"           # Find files by name
find /var -type f -size +100M  # Find files larger than 100MB
```

### Text Processing
```bash
echo "Hello World"             # Print text
echo $PATH                     # Print environment variable
sort file.txt                  # Sort lines
uniq file.txt                  # Remove duplicate adjacent lines
sort file.txt | uniq           # Sort then remove duplicates
cut -d',' -f1 data.csv         # Extract first column (comma delimiter)
wc -l file.txt                 # Count lines
```

### System Information
```bash
top                    # Live process viewer (q to quit)
htop                   # Better top (install it: apt install htop)
ps aux                 # List all processes
df -h                  # Disk space (human-readable)
du -sh folder/         # Directory size
free -h                # Memory usage
uname -a               # System information
```

### The Pipe `|`

This is where Linux gets powerful. You can chain commands together:

```bash
cat log.txt | grep "error" | sort | uniq -c | sort -rn | head -10
```

Translation: "Show me the 10 most common error messages in this log."

Each `|` takes the output of one command and feeds it to the next. This is the Unix philosophy in action: small tools that do one thing well, combined to do complex things.

---

## The Text Editor Debate

You need a terminal text editor. Files on servers need editing, and you won't have VS Code there.

**The options:**
- **nano:** Beginner-friendly. Controls shown at bottom. `Ctrl+X` to exit.
- **vim:** Powerful but steep learning curve. The "I can't exit" meme editor.
- **emacs:** The "operating system disguised as a text editor."

**My recommendation:** Learn `nano` first for quick edits. Then learn basic `vim` because you _will_ encounter it.

**Vim survival guide:**
```
i          # Enter insert mode (now you can type)
Esc        # Exit insert mode
:w         # Save
:q         # Quit
:wq        # Save and quit
:q!        # Quit without saving (force)
```

If you accidentally open vim and panic, just type `:q!` and hit Enter. You're free.

![[Attachments/exit-vim-meme.jpeg]]

---

## Package Management

Installing software on Linux is done through package managers, not downloading `.exe` files from random websites.

**Ubuntu/Debian:**
```bash
sudo apt update              # Refresh package list
sudo apt upgrade             # Upgrade installed packages
sudo apt install nginx       # Install a package
sudo apt remove nginx        # Remove a package
sudo apt search "web server" # Search for packages
```

**CentOS/RHEL:**
```bash
sudo dnf update              # Refresh and upgrade
sudo dnf install nginx       # Install a package
sudo dnf remove nginx        # Remove a package
sudo dnf search "web server" # Search for packages
```

**Why this matters:**
- Packages come from trusted repositories
- Dependencies are handled automatically
- Updates are centralized
- No hunting for download links

---

## The sudo Situation

![[Attachments/sudo-power-meme.png]]

`sudo` means "superuser do." It runs a command with root (admin) privileges.

```bash
apt install nginx        # Permission denied
sudo apt install nginx   # Works (after password)
```

**The rules:**
- Use `sudo` only when necessary
- Never run everything as root
- `sudo rm -rf /` will destroy your system (don't try it)
- If a tutorial says "just run everything as root," find a better tutorial

**Becoming root (use sparingly):**
```bash
sudo su         # Switch to root user
exit            # Go back to normal user
```

---

## What This Week Is Really About

Linux isn't about memorizing commands. It's about getting comfortable with the terminal as your primary interface.

**Key takeaways:**
- Linux dominates the server world, embrace it
- Start with Ubuntu, the skills transfer to other distros
- The terminal is faster and more powerful than any GUI
- Understand the directory structure, it's consistent everywhere
- Permissions matter, don't chmod 777 your way out of problems
- You don't need to memorize everything, just know what's possible and look up the syntax

The goal isn't to become a Linux wizard overnight. It's to stop being afraid of that blinking cursor. Every command you learn is a tool in your belt. The more tools you have, the faster you can solve problems.

And remember, everyone who's good at Linux was once Googling "how to exit vim." You'll get there.

---

## Resources

**Linux Fundamentals:**
- [Introduction to Linux - LinuxFoundationX](https://www.edx.org/learn/linux/the-linux-foundation-introduction-to-linux) - A good starting point promoted by Linus Torvalds himself
- [Introduction to Linux (Chapters 1-6) - freeCodeCamp](https://www.freecodecamp.org/news/introduction-to-linux/) - Covers all the fundamentals

**Command Line:**
- [The Linux Command Line - William Shotts](https://linuxcommand.org/tlcl.php) - Free book, comprehensive
- [ExplainShell](https://explainshell.com/) - Paste a command, get an explanation
- [tldr pages](https://tldr.sh/) - Simplified man pages with practical examples

**Practice:**
- [OverTheWire: Bandit](https://overthewire.org/wargames/bandit/) - Learn Linux through a game
- [Linux Journey](https://linuxjourney.com/) - Interactive Linux learning

**Vim:**
- [Vim Adventures](https://vim-adventures.com/) - Learn Vim through a game
- [OpenVim](https://www.openvim.com/) - Interactive Vim tutorial
