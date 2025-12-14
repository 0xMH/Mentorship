---
week: 4
topic: Linux Fundamentals & The Terminal
---

## Overview
This week focuses on getting comfortable with Linux and the command line. You'll learn essential commands, understand the file system, and practice navigating servers like a real DevOps engineer.

---

## Tasks

### 1. Linux Fundamentals
Build your foundation in Linux concepts and the terminal.

#### Learning Resources
**Video Learner?**
- [ ] Watch [Introduction to Linux - Full Course](https://www.youtube.com/watch?v=sWbUDq4S6Y8) (6 hours) - Great overview, watch at 1.5x if needed
- [ ] Watch [Linux File System Explained](https://www.youtube.com/watch?v=HbgzrKJvDRw) (15 mins)

**Prefer Reading?**
- [ ] Read [Introduction to Linux (Chapters 1-6)](https://www.freecodecamp.org/news/introduction-to-linux/) - Covers all the fundamentals
- [ ] Read [Linux Journey - Command Line](https://linuxjourney.com/lesson/the-shell) - Interactive and beginner-friendly
- [ ] Skim [The Linux Command Line (Chapters 1-4)](https://linuxcommand.org/tlcl.php) - Free book, comprehensive


**Key Concepts to Understand:**
- What is Linux and why does it dominate servers?
- What's the difference between Debian/Ubuntu and RHEL/CentOS families?
- Why use the terminal when GUIs exist?
- What does "everything is a file" mean in Linux?

---

### 2. Essential Commands
Master the commands you'll use every single day.

#### Learning Resources
**Video Learner?**
- [ ] Watch [60 Linux Commands in 10 Minutes](https://www.youtube.com/watch?v=gd7BXuUQ91w) (10 mins) - Fast overview
- [ ] Watch [Linux Terminal for Beginners](https://www.youtube.com/watch?v=s3ii48qYBxA) (45 mins)

**Prefer Reading?**
- [ ] Read [50+ Essential Linux Commands](https://www.digitalocean.com/community/tutorials/linux-commands) - DigitalOcean's comprehensive guide
- [ ] Read [20 Essential Linux Commands](https://www.redhat.com/en/blog/20-essential-linux-commands-every-user) - Red Hat's quick rundown
- [ ] Read [Command Line for Beginners](https://ubuntu.com/tutorials/command-line-for-beginners) - Ubuntu's official tutorial
- [ ] Read [Linux Tutorial](https://ryanstutorials.net/linuxtutorial/) - 13-part series, very beginner-friendly

**Check out:**
- [ ] Bookmark [ExplainShell](https://explainshell.com/) - Paste any command, get an explanation
- [ ] Install [tldr pages](https://tldr.sh/) - Simplified man pages with examples

#### Practice Goals
- [ ] Open a terminal (use WSL on Windows, Terminal on Mac, or spin up an Ubuntu VM)
- [ ] Practice navigation commands:
  - [ ] Use `pwd` to see where you are
  - [ ] Use `ls -la` to list files with details
  - [ ] Use `cd` to move around (try `cd ~`, `cd ..`, `cd -`)
- [ ] Practice file operations:
  - [ ] Create a directory with `mkdir practice-linux`
  - [ ] Create files with `touch file1.txt file2.txt`
  - [ ] Copy, move, and rename files with `cp` and `mv`
  - [ ] Delete files carefully with `rm` (no undo!)
- [ ] Practice reading files:
  - [ ] Use `cat`, `less`, `head`, and `tail` on different files
  - [ ] Try `tail -f /var/log/syslog` to watch logs in real-time (Ctrl+C to exit)
- [ ] Practice searching:
  - [ ] Use `grep "error" filename` to search inside files
  - [ ] Use `find . -name "*.txt"` to find files by name

---

### 3. Permissions & Ownership
Understand how Linux controls who can do what.

#### Learning Resources
**Video Learner?**
- [ ] Watch [Linux File Permissions Explained](https://www.youtube.com/watch?v=D-VqgvBMV7g) (12 mins)

**Prefer Reading?**
- [ ] Read [Linux Permissions Guide](https://linuxhandbook.com/linux-file-permissions/) - Clear breakdown with examples
- [ ] Read [Understanding chmod](https://www.howtogeek.com/437958/how-to-use-the-chmod-command-on-linux/)

#### Practice Goals
- [ ] Run `ls -l` and understand the output (rwx permissions, owner, group)
- [ ] Create a test file and practice changing permissions:
  - [ ] `chmod 755 testfile` - Make it executable
  - [ ] `chmod +x script.sh` - Add execute permission
  - [ ] `chmod 644 testfile` - Standard file permissions
- [ ] Understand why `chmod 777` is almost always wrong

**Key Concepts to Understand:**
- What do read (r), write (w), and execute (x) mean?
- What's the difference between owner, group, and others?
- How do numeric permissions (755, 644) map to rwx?

---

### 4. Package Management
Learn how to install software the Linux way.

#### Practice Goals
- [ ] Update your package list: `sudo apt update` (Ubuntu) or `sudo dnf update` (CentOS)
- [ ] Install a package: `sudo apt install htop` or `sudo dnf install htop`
- [ ] Run `htop` to see a better process viewer (press `q` to quit)
- [ ] Search for packages: `apt search "web server"`
- [ ] Remove a package: `sudo apt remove htop`

---

### 5. Text Editors (Survival Mode)
You will encounter vim. Be prepared.

#### Learning Resources
**Video Learner?**
- [ ] Watch [Vim Basics in 8 Minutes](https://www.youtube.com/watch?v=ggSyF1SVFr4) (8 mins)

**Prefer Reading?**
- [ ] Try [OpenVim](https://www.openvim.com/) - Interactive vim tutorial in your browser
- [ ] Bookmark the vim survival commands: `i` (insert), `Esc` (exit insert), `:wq` (save & quit), `:q!` (quit without saving)

#### Practice Goals
- [ ] Open a file with `nano filename` - Edit something, save with Ctrl+O, exit with Ctrl+X
- [ ] Open a file with `vim filename` - Practice the survival commands
- [ ] Successfully exit vim without Googling (you'll feel proud)

---

### 6. Pipes & Redirection
This is where Linux gets powerful.

#### Practice Goals
- [ ] Try chaining commands with pipes:
  - [ ] `cat /etc/passwd | grep "root"`
  - [ ] `ls -la | less`
  - [ ] `history | grep "git"`
- [ ] Try output redirection:
  - [ ] `echo "Hello" > file.txt` (overwrites)
  - [ ] `echo "World" >> file.txt` (appends)
  - [ ] `ls -la > directory-listing.txt`

**Key Concepts to Understand:**
- What does the pipe `|` actually do?
- What's the difference between `>` and `>>`?

---

## Bonus Challenge
- [ ] Complete levels 0-10 of [OverTheWire: Bandit](https://overthewire.org/wargames/bandit/) - Learn Linux through a game
- [ ] Try [Vim Adventures](https://vim-adventures.com/) - Learn vim through a game
- [ ] Set up a free Ubuntu VM on [DigitalOcean](https://www.digitalocean.com/) or [Linode](https://www.linode.com/) and SSH into it

---

## Extra Reading (Optional)
If you want to go deeper:
- [ ] [Introduction to Linux - LinuxFoundationX](https://www.edx.org/learn/linux/the-linux-foundation-introduction-to-linux) - Full course promoted by Linus Torvalds
- [ ] [The Linux Command Line - Full Book](https://linuxcommand.org/tlcl.php) - Comprehensive free book
- [ ] [Linux Journey - Full Course](https://linuxjourney.com/) - All modules from beginner to advanced

---

## Reference
- [[Curriculums/Week-4|Week 4 Curriculum]]
