---
wizard: D
week: 5
topic: Network Debugging Tools
status: not-started
type: tasks
---

# Week 5: Network Debugging Tools - Wizard D

```meta-bind-button
label: 📝 My Notes & Reflection
icon: ""
style: primary
actions:
  - type: open
    link: "Wizards/D/Week-5/Notes"
```

## Overview
This week focuses on mastering network debugging tools. You'll learn how to diagnose connectivity issues, trace network paths, and stop saying "it's not working" without knowing why.

---

## Tasks

### 1. Understanding the Debugging Mental Model
Before diving into tools, understand how to think about network problems.

#### Learning Resources
- [x] Read [Linux Troubleshooting](https://www.billdietrich.me/LinuxTroubleshooting.html) - General Linux debugging reference
- [x] Read [Linux Networking Troubleshooting](https://www.billdietrich.me/LinuxNetworking.html#Troubleshooting) - Bill Dietrich's comprehensive guide
- [x] Read [Linux Network Troubleshooting Guide](https://www.redhat.com/sysadmin/beginners-guide-network-troubleshooting-linux) - Red Hat's beginner guide
- [x] Read [How to Troubleshoot Your Network on Linux](https://www.freecodecamp.org/news/how-troubleshoot-network-on-linux/) - freeCodeCamp's OSI model approach



**Key Concepts to Understand:**
- What's the chain from your app to the remote server?
- Why should you start simple and escalate to complex tools?
- How do you systematically eliminate possibilities?

---

### 2. Basic Connectivity Tools (ping, traceroute, mtr)
Learn how to check if a host is reachable and trace the network path.

#### Learning Resources
- [x] Read [How to Use Traceroute and MTR](https://www.digitalocean.com/community/tutorials/how-to-use-traceroute-and-mtr-to-diagnose-network-issues) - DigitalOcean's comprehensive guide
- [x] Read [What is traceroute?](https://www.cloudflare.com/learning/network-layer/what-is-traceroute/) - Cloudflare's breakdown
- [x] Read [What is MTR?](https://www.cloudflare.com/learning/network-layer/what-is-mtr/) - Cloudflare explains mtr

#### Practice Goals
- [x] Open a terminal and try basic ping:
  - [x] `ping google.com` - Does it respond?
  - [x] `ping -c 4 8.8.8.8` - Ping by IP (bypasses DNS)
  - [x] `ping -c 4 localhost` - Ping yourself
- [x] Trace the network path:
  - [x] `traceroute google.com` - See the hops
  - [x] Notice where latency increases
  - [x] Try `mtr google.com` if installed (combines ping + traceroute, press `q` to quit)
- [x] Test a failing scenario:
  - [x] `ping nonexistent.invalid` - See what DNS failure looks like

---

### 3. DNS Debugging (dig, nslookup)
DNS breaks more things than you'd expect. Learn to investigate it.

#### Learning Resources
- [x] Read [How to Use the dig Command](https://www.learnlinux.tv/how-to-use-the-dig-command-in-linux-dns-lookup-tutorial/) - LearnLinuxTV guide
- [x] Read [dig Command Examples](https://www.madboa.com/geek/dig/) - Comprehensive reference
- [x] Read [Linux dig Command Examples](https://www.cyberciti.biz/faq/linux-unix-dig-command-examples-usage-syntax/) - nixCraft guide

#### Practice Goals
- [x] Practice basic DNS lookups:
  - [x] `dig google.com` - Full output
  - [x] `dig google.com +short` - Just the IP
  - [x] `nslookup google.com` - Alternative tool
- [x] Query specific DNS servers:
  - [x] `dig @8.8.8.8 google.com` - Use Google's DNS
  - [x] `dig @1.1.1.1 google.com` - Use Cloudflare's DNS
  - [x] Compare results - are they the same?
- [x] Check different record types:
  - [x] `dig google.com MX` - Mail servers
  - [x] `dig google.com NS` - Nameservers
  - [x] `dig google.com TXT` - Text records

**Key Concepts to Understand:**
- What's the difference between A, MX, NS, and CNAME records?
- Why would you query a specific DNS server instead of your default?
- How do you know if DNS is the problem?

---

### 4. HTTP Debugging (curl)
curl is your Swiss Army knife for anything HTTP.

#### Learning Resources
- [ ] Read [curl Tutorial](https://curl.se/docs/tutorial.html) - Official documentation
- [ ] Read [curl Cookbook](https://catonmat.net/cookbooks/curl) - Everything curl can do
- [ ] Read [curl by Example](https://antonz.org/curl-by-example/) - Interactive guide
- [ ] Read [How to start using Curl](https://www.freecodecamp.org/news/how-to-start-using-curl-and-why-a-hands-on-introduction-ea1c913caaaa/) - freeCodeCamp intro

#### Practice Goals
- [ ] Try basic requests:
  - [ ] `curl https://httpbin.org/get` - Simple GET request
  - [ ] `curl -I https://google.com` - Headers only
  - [ ] `curl -v https://google.com` - Verbose mode (see everything)
- [ ] Test response codes:
  - [ ] `curl -s -o /dev/null -w "%{http_code}" https://google.com` - Just the status code
  - [ ] `curl -L https://google.com` - Follow redirects
- [ ] Send data:
  - [ ] `curl -X POST https://httpbin.org/post -d "name=test"` - POST request
  - [ ] `curl -X POST https://httpbin.org/post -H "Content-Type: application/json" -d '{"name":"Ahmed"}'` - POST JSON
- [ ] Debug a timeout:
  - [ ] `curl --connect-timeout 5 --max-time 10 https://httpbin.org/delay/3` - Set timeouts

**Key Concepts to Understand:**
- What does the `-v` flag show you?
- How do you know if the problem is DNS, connection, or the application?
- When would you use `-k` to ignore SSL errors (and why is it risky)?

---

### 5. Port & Connection Debugging (ss, netcat)
Check what's listening and test if ports are open.

#### Learning Resources
- [ ] Read [ss Command Examples](https://www.cyberciti.biz/tips/linux-investigate-sockets-network-connections.html) - nixCraft comprehensive guide
- [ ] Read [netstat vs ss Usage Guide](https://computingforgeeks.com/netstat-vs-ss-usage-guide-linux/) - Comparison with examples
- [ ] Read [How to Use Netcat](https://www.digitalocean.com/community/tutorials/how-to-use-netcat-to-establish-and-test-tcp-and-udp-connections) - DigitalOcean guide
- [ ] Read [Netcat Commands Cheat Sheet](https://www.varonis.com/blog/netcat-commands) - Varonis quick reference

#### Practice Goals
- [ ] Check what's listening on your machine:
  - [ ] `ss -tlnp` - TCP listeners with process info
  - [ ] `ss -ulnp` - UDP listeners
  - [ ] `ss -tnp | grep ESTAB` - Established connections
- [ ] Test remote port connectivity:
  - [ ] `nc -zv google.com 443` - Is HTTPS port open?
  - [ ] `nc -zv google.com 80` - Is HTTP port open?
  - [ ] `nc -zv localhost 22` - Is SSH running locally?
- [ ] Understand binding differences:
  - [ ] Notice if a service listens on `127.0.0.1` vs `0.0.0.0`
  - [ ] Understand why this matters for remote access

**Key Concepts to Understand:**
- What does "connection refused" actually mean?
- What's the difference between `127.0.0.1` and `0.0.0.0`?
- Why is `ss` preferred over `netstat`?

---

### 6. Packet Capture Basics (tcpdump)
When you need to see what's actually happening on the wire.

#### Learning Resources
- [ ] Read [tcpdump Tutorial](https://danielmiessler.com/p/tcpdump/) - Daniel Miessler's excellent guide
- [ ] Read [tcpdump for Beginners](https://www.cloudns.net/blog/tcpdump-for-beginners-what-it-is-how-to-install-and-key-commands/) - ClouDNS intro
- [ ] Read [Linux tcpdump Command Tutorial](https://www.howtoforge.com/linux-tcpdump-command/) - HowToForge examples

#### Practice Goals
- [ ] Capture some traffic (requires sudo):
  - [ ] `sudo tcpdump -i any -c 10` - Capture 10 packets on any interface
  - [ ] `sudo tcpdump -i any port 80 -c 5` - Only HTTP traffic
  - [ ] `sudo tcpdump -i any host google.com -c 5` - Only traffic to/from Google
- [ ] Save and read captures:
  - [ ] `sudo tcpdump -i any -c 20 -w capture.pcap` - Save to file
  - [ ] `tcpdump -r capture.pcap` - Read from file
- [ ] Filter by protocol:
  - [ ] `sudo tcpdump -i any icmp -c 5` - Only ping traffic (run `ping google.com` in another terminal)

**Key Concepts to Understand:**
- When would you use tcpdump vs curl?
- What does it mean if tcpdump shows nothing?
- Why would you save to a file instead of reading live?

---

### 7. Put It All Together
Practice the systematic debugging workflow.

#### Practice Goals
- [ ] Debug a simulated "connection issue" step by step:
  - [ ] Pick a website (e.g., `httpbin.org`)
  - [ ] Step 1: `dig httpbin.org +short` - Can you resolve DNS?
  - [ ] Step 2: `ping -c 4 <IP from step 1>` - Can you reach it?
  - [ ] Step 3: `nc -zv httpbin.org 443` - Is the port open?
  - [ ] Step 4: `curl -v https://httpbin.org/get` - Does HTTP work?
- [ ] Practice on a local service:
  - [ ] Start a simple server: `python3 -m http.server 8080`
  - [ ] In another terminal: `ss -tlnp | grep 8080` - Is it listening?
  - [ ] `curl localhost:8080` - Can you connect?
  - [ ] `curl <your-ip>:8080` - Can you connect from "outside"?

---

## Bonus Challenge
- [ ] Try [SadServers](https://sadservers.com/) - Debug broken Linux servers (look for networking scenarios)
- [ ] Set up a simple firewall rule with `ufw` or `iptables`, then debug why your connection stops working
- [ ] Use Wireshark (GUI) to open a `.pcap` file and explore the packet details

---

## Extra Reading (Optional)
If you want to go deeper:
- [ ] [Linux Network Debugging Cheatsheet](https://gist.github.com/tuxfight3r/9ac030cb0d707bb446c7) - Quick reference
- [ ] [mtr Manual](https://www.bitwizard.nl/mtr/) - Deep dive into mtr
- [ ] [The Book of Secret Knowledge - Network Section](https://github.com/trimstray/the-book-of-secret-knowledge#black_small_square-network) - Curated resources

---

## Reference
- [[Curriculums/Week-5|Week 5 Curriculum]]


## Reference
- [[Wizards/D/Week-5/Notes|My Notes & Reflection]]
- [[Curriculums/Week-5|Week 5 Curriculum]]
- [[Wizards/D/🧙‍♂️🪄 Grimoire|My Grimoire]]
