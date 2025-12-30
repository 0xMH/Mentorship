---
week: 5
topic: Network Debugging Tools
share_link:
share_updated:
---
# Network Debugging: When "It's Not Working" Isn't Enough

> **The network is never the problem. Until it is. And then it's always the network.**

Here's the thing about network issues. They're invisible. You can't see packets flying through the air. You can't watch DNS queries resolve. When something breaks, all you get is a vague error message and a lot of frustration.

"Connection refused." "Host unreachable." "Request timed out."

Cool. Thanks. Very helpful.

This is why network debugging tools exist. They let you see the invisible. And once you can see what's happening, fixing it becomes a lot less like guessing and a lot more like engineering.

### Why Network Debugging Matters

Every modern application is a distributed system. Your code talks to databases, APIs, message queues, and third-party services. When any of those connections fail, your app fails.

**The junior approach:**
```
App not working → "The server is down" → Restart everything → Hope it works
```

**The old man's approach:**
```
App not working → Check connectivity → Check DNS → Check ports → Check Services → Find actual problem → Fix it
```

The difference? One takes 5 minutes. The other takes 3 hours and might not even work.

---

## The Debugging Mental Model

Before we dive into tools, let's talk about _how_ to think about network problems.

When a connection fails, it fails somewhere in this chain:

```
Your App → Local Network → DNS → Internet → Remote Network → Remote Server → Remote App
    1            2           3       4            5              6             7
```

Your job is to figure out _where_ it broke. Each tool we'll cover helps you test a different part of this chain.

**The principle:**
> Start from your machine and work outward. Eliminate possibilities systematically.

![[Attachments/works-on-my-machine-meme.png]]

---

## ping: Is It Even Alive?

`ping` is the "hello, are you there?" of networking. It sends a tiny packet to a server and waits for a response.

```bash
ping google.com
```

```
PING google.com (142.250.185.78): 56 data bytes
64 bytes from 142.250.185.78: icmp_seq=0 ttl=117 time=12.3 ms
64 bytes from 142.250.185.78: icmp_seq=1 ttl=117 time=11.8 ms
64 bytes from 142.250.185.78: icmp_seq=2 ttl=117 time=12.1 ms
```

**What you're looking for:**
- **Responses:** The host is reachable at the network level
- **Time (ms):** How long the round trip takes (lower is better)
- **Packet loss:** If some packets don't come back, you have an unstable connection

**Common scenarios:**

| Result                             | Meaning                           |
| ---------------------------------- | --------------------------------- |
| Replies with low latency           | Connection is healthy             |
| Replies with high latency (>200ms) | Network congestion or distance    |
| Request timeout                    | Host unreachable or blocking ICMP |
| Unknown host                       | DNS resolution failed             |

**Real talk:** Many servers block ping (ICMP) for security reasons. So "ping fails" doesn't always mean "server is down." It might just mean ping is blocked. Don't stop here.

```bash
ping -c 4 google.com    # Send only 4 pings (otherwise it runs forever on Linux)
ping -c 4 8.8.8.8       # Ping by IP (bypasses DNS, tests raw connectivity)
```

---

## curl: The HTTP Swiss Army Knife

If `ping` checks if a server is alive, `curl` checks if the _application_ is responding. This is your go-to tool for debugging anything HTTP.

```bash
curl https://api.example.com/health
```

**Basic usage:**
```bash
curl https://example.com                    # GET request, show response body
curl -I https://example.com                 # HEAD request, show headers only
curl -v https://example.com                 # Verbose mode, show everything
curl -o file.html https://example.com       # Save response to file
```

**The verbose flag (`-v`) is your friend:**
```bash
curl -v https://api.example.com/users
```

This shows you:
- DNS resolution
- TCP connection
- TLS handshake
- Request headers sent
- Response headers received
- Response body

When something's broken, `-v` tells you _where_ it broke.

**Testing specific things:**
```bash
# Check response code without downloading the whole page
curl -s -o /dev/null -w "%{http_code}" https://example.com

# Send POST request with JSON
curl -X POST https://api.example.com/users \
  -H "Content-Type: application/json" \
  -d '{"name": "Ahmed", "email": "ahmed@example.com"}'

# Follow redirects
curl -L https://example.com

# Set timeout (don't wait forever)
curl --connect-timeout 5 --max-time 10 https://slow-api.example.com

# Ignore SSL certificate errors 
curl -k https://self-signed.example.com
```

**Key insight:** If `curl` works but your app doesn't, the problem is in your app, not the network.

![[Attachments/its-all-curl-meme.jpeg]]

---

## dig: DNS Detective Work

DNS is the phonebook of the internet. It translates `google.com` to `142.250.185.78`. When DNS breaks, _everything_ breaks.

```bash
dig google.com
```

```
;; ANSWER SECTION:
google.com.		300	IN	A	142.250.185.78
```

**What you're looking for:**
- **ANSWER SECTION:** The resolved IP address(es)
- **Query time:** How long the lookup took
- **SERVER:** Which DNS server answered

**Common dig commands:**
```bash
dig example.com                  # Basic A record lookup
dig example.com +short           # Just show the IP, nothing else
dig @8.8.8.8 example.com         # Query specific DNS server (Google's)
dig example.com MX               # Mail server records
dig example.com NS               # Nameserver records
dig example.com ANY              # All records (if allowed)
dig +trace example.com           # Trace the full DNS resolution path
```

**Debugging DNS issues:**

```bash
# Compare your DNS vs public DNS
dig example.com +short
dig @8.8.8.8 example.com +short
dig @1.1.1.1 example.com +short
```

If your local DNS returns something different (or nothing), your DNS is the problem.

**The alternative, nslookup:**
```bash
nslookup example.com
nslookup example.com 8.8.8.8    # Query specific server
```

`nslookup` is simpler but less powerful. Use `dig` when you need details, `nslookup` for quick checks.

**Spoiler:** 90% of "the site is down" issues are DNS. Always check DNS first.

![[Attachments/its-always-dns-meme.jpeg]]

---

## ss and netstat: What's Listening Where?

Your server might be running, but is it actually listening on the right port?

```bash
ss -tlnp
```

```
State    Recv-Q   Send-Q   Local Address:Port   Peer Address:Port   Process
LISTEN   0        128      0.0.0.0:22            0.0.0.0:*           sshd
LISTEN   0        128      0.0.0.0:80            0.0.0.0:*           nginx
LISTEN   0        128      127.0.0.1:5432        0.0.0.0:*           postgres
```

**Breaking down the flags:**
- `-t` TCP connections
- `-l` Only listening sockets
- `-n` Show port numbers (not service names)
- `-p` Show process using the port

**Common scenarios:**
```bash
ss -tlnp                        # What's listening? (TCP)
ss -ulnp                        # What's listening? (UDP)
ss -tnp                         # Active connections (not just listening)
ss -tnp | grep ESTAB            # Established connections only
ss -tnp | grep :443             # Connections on port 443
```

**Real talk:** `netstat` is the old-school version. It still works, but `ss` is faster and more modern. Use `ss` unless you're on an ancient system.

```bash
# netstat equivalent (if ss isn't available)
netstat -tlnp
```

**Key insight:** If nothing is listening on the port you expect, either the service isn't running or it's bound to a different interface (like `127.0.0.1` instead of `0.0.0.0`).

---

## traceroute: Following the Path

When ping fails, `traceroute` shows you _where_ it fails. It maps the path packets take from your machine to the destination.

```bash
traceroute google.com
```

```
 1  router.local (192.168.1.1)  1.234 ms  1.123 ms  1.089 ms
 2  isp-gateway (10.0.0.1)  12.345 ms  11.234 ms  12.567 ms
 3  * * *
 4  core-router.isp.net (203.0.113.1)  25.678 ms  24.567 ms  25.123 ms
 5  google-peer (142.250.0.1)  30.123 ms  29.876 ms  30.234 ms
```

**What you're looking for:**
- **Increasing latency:** Normal, packets travel further
- **Sudden spike:** Congestion or problem at that hop
- **`* * *`:** That router isn't responding (might be blocking ICMP)
- **Stops completely:** Network is unreachable past that point

**Variations:**
```bash
traceroute google.com           # ICMP-based (might be blocked)
traceroute -T google.com        # TCP-based (better success rate)
traceroute -p 443 google.com    # Use specific port
mtr google.com                  # Combines ping + traceroute (real-time)
```

**mtr is traceroute on steroids:**
```bash
mtr google.com
```

It continuously runs and shows you packet loss and latency at each hop. Great for diagnosing intermittent issues.

---

## netcat (nc): The Network Multitool

`netcat` is like a raw network connection. It can do almost anything: port scanning, file transfers, chat, you name it.

**Check if a port is open:**
```bash
nc -zv example.com 443
```
```
Connection to example.com 443 port [tcp/https] succeeded!
```

**Flags:**
- `-z` Scan mode (don't send data)
- `-v` Verbose

**Common uses:**
```bash
# Check if port is open
nc -zv example.com 80
nc -zv example.com 22
nc -zv example.com 5432

# Check multiple ports
nc -zv example.com 80 443 8080

# With timeout
nc -zv -w 3 example.com 443
```

**Real talk:** `nc` is often faster than `curl` for checking if a port is open. Use it as a quick "is this port accepting connections?" check.

**Simple connection test:**
```bash
# Connect and type raw HTTP (for debugging)
nc example.com 80
GET / HTTP/1.1
Host: example.com

```

---

## tcpdump: When You Need to See Everything

Sometimes you need to see the actual packets. `tcpdump` captures network traffic in real-time.

**Basic usage:**
```bash
sudo tcpdump -i eth0                    # Capture all traffic on interface
sudo tcpdump -i any                     # Capture on all interfaces
sudo tcpdump -i eth0 port 80            # Only HTTP traffic
sudo tcpdump -i eth0 host 192.168.1.100 # Only traffic to/from specific host
```

**Useful filters:**
```bash
# Capture traffic to specific port
sudo tcpdump -i any port 443

# Capture traffic to specific host
sudo tcpdump -i any host api.example.com

# Capture only TCP SYN packets (connection attempts)
sudo tcpdump -i any 'tcp[tcpflags] & tcp-syn != 0'

# Save to file for later analysis
sudo tcpdump -i any -w capture.pcap

# Read from file
tcpdump -r capture.pcap
```

**Key insight:** If you capture traffic and see nothing, packets aren't even reaching your machine. The problem is upstream.

**Real talk:** `tcpdump` output is dense. For serious analysis, capture to a file and open it in Wireshark (GUI tool). But knowing basic `tcpdump` is essential for server debugging where you don't have a GUI.

---

## Putting It All Together: The Debugging Workflow

Here's how to systematically debug "it's not connecting":

```
1. Can I resolve the hostname?
   → dig api.example.com

2. Can I reach the IP?
   → ping 203.0.113.50

3. Is the port open?
   → nc -zv 203.0.113.50 443

4. Does HTTP work?
   → curl -v https://api.example.com/health

5. Where does it fail?
   → traceroute api.example.com

6. What's actually happening on the wire?
   → tcpdump -i any host api.example.com
```

**The debugging cheat sheet:**

| Symptom | First Tool | What It Tells You |
|---------|------------|-------------------|
| "Unknown host" | `dig` | DNS isn't resolving |
| "Connection refused" | `ss -tlnp` | Nothing listening on that port |
| "Connection timed out" | `ping`, `traceroute` | Network path is broken |
| "SSL certificate error" | `curl -v` | Certificate chain issue |
| "Intermittent failures" | `mtr` | Packet loss somewhere in path |
| "Works locally, fails remotely" | `ss -tlnp` | Check if bound to 127.0.0.1 vs 0.0.0.0 |

---

## Common Gotchas

**1. Firewall blocking traffic**

![[Attachments/firewall-meme.png]]

```bash
# Check if iptables is blocking
sudo iptables -L -n

# Check if ufw is active (Ubuntu)
sudo ufw status
```

**2. Service bound to localhost only**
```bash
# Bad: Only accessible from same machine
LISTEN   127.0.0.1:5432

# Good: Accessible from anywhere
LISTEN   0.0.0.0:5432
```

**3. DNS caching**
```bash
# Your machine might have cached old DNS
# Try querying public DNS directly
dig @8.8.8.8 example.com

# Flush DNS cache (varies by OS)
# macOS
sudo dscacheutil -flushcache

# Ubuntu
sudo systemd-resolve --flush-caches
```

**4. MTU issues (rare but painful)**
```bash
# If large packets fail but small ones work
ping -s 1472 example.com    # Test with larger packet size
```

---

## What This Week Is Really About

Network debugging isn't about memorizing commands. It's about building a mental model of how data flows and knowing which tool illuminates which part of that flow.

**Key takeaways:**
- Start simple (`ping`, `dig`) and escalate to complex (`tcpdump`) as needed
- DNS is guilty until proven innocent
- `curl -v` is your best friend for HTTP debugging
- If nothing is listening, the network isn't the problem, the service is
- `ss` over `netstat`, `dig` over `nslookup`, `mtr` over `traceroute`
- When in doubt, check the firewall

The best network debuggers aren't the ones who know every flag. They're the ones who systematically eliminate possibilities until only the truth remains.

And remember, when someone says "it's a network issue," they usually mean "I don't know what the issue is." Now you have the tools to find out.

---

## Resources

**General Network Debugging:**
- [Linux Network Debugging Cheatsheet](https://gist.github.com/tuxfight3r/9ac030cb0d707bb446c7) - Quick reference
- [Networking Commands Every Developer Should Know](https://www.redhat.com/sysadmin/beginners-guide-network-troubleshooting-linux) - Red Hat's guide

**Individual Tools:**
- [curl Cookbook](https://catonmat.net/cookbooks/curl) - Everything curl can do
- [dig HOWTO](https://www.madboa.com/geek/dig/) - Deep dive into dig
- [tcpdump Tutorial](https://danielmiessler.com/study/tcpdump/) - Daniel Miessler's excellent guide
- [mtr Manual](https://www.bitwizard.nl/mtr/) - Official mtr documentation

**Practice:**
- [SadServers](https://sadservers.com/) - Debug broken Linux servers (includes network scenarios)
- [Network Troubleshooting Scenarios](https://github.com/trimstray/the-book-of-secret-knowledge#black_small_square-network) - Real-world examples

**Reference:**
- [ExplainShell](https://explainshell.com/) - Paste any command for explanation
- [SS Utility Cheatsheet](https://www.cyberciti.biz/tips/linux-investigate-sockets-network-connections.html) - ss command examples
