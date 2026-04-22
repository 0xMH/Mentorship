


# How DNS resolve work


Lets imagine we are in scenario where there is a connection problem to some server(google.com) and while troubleshooting as stated in [[Week-5]] the problem we found is a DNS problem. Now how to solve it ??


First Lets understand how DNS resolver work:

```bash 
ping google.com
```

1. `getaddrinfo()` from libc will be called

2. the function will read `/etc/nsswitch.conf` which is a file sets the order of sources for various services. the important line  in our situation is hosts line 
```bash
ali-mohamed@Ali-PC:~$ cat /etc/nsswitch.conf | grep hosts
hosts:          files mdns4_minimal [NOTFOUND=return] dns
```

These are the modules that will be used in host to IP resolution. The order is go from left to right:
	1. `file` : It will read /etc/hosts file and see if there is mapping to host there
	2. `mdns4_minimal` : It is a module that search the local LAN using mDNS handling all hosts end with .local by default
	3. `NOTFOUND=return` : It is a condition to return if the host is local one (searched in local lan) and not found.
	4. `dns` : It is the module responsable for DNS resolution trough internet (our hero)

So If `dns` is missing here even . the server will not resolve any public host. This is a snapshot of what /etc/hosts look like:

```bash
cat /etc/hosts

# this is why anytime we search by localhost it will resolved directly to # 127.0.0.1
127.0.0.1 localhost
127.0.1.1 Ali-PC
```

3. Now return to our case , google.com is not in  `/etc/hosts` or end with `local` , so the module responsible for the resolution of our Query is the **dns** module.
4. DNS module read `/etc/resolv.conf` that contains nameserver up to 3 asked in order untill our query is done.

```bash
ali-mohamed@Ali-PC:~$ cat /etc/resolv.conf

nameserver 8.8.8.8
nameserver 1.1.1.1
options edns0 trust-ad
search test

```


>  **Search Field** : it is a domain  will be appended at the end of the host if it contians number of dots less than ndots (default 1). 
>  EX:  if I query (something), it will be (something.test)

Using **tcpdump** , lets see what happens in the wire ( I removed ipv6 statments):
``` 
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on any, link-type LINUX_SLL2 (Linux cooked v2), snapshot length 262144 bytes
16:10:59.919676 wlo1  Out IP 192.168.1.8.42914 > 8.8.8.8.53: 25791+ [1au] A? google.com. (39)
16:11:00.052281 wlo1  In  IP 8.8.8.8.53 > 192.168.1.8.42914: 25791 1/0/1 A 142.250.200.238 (55)
```

As we can see here when I ping google.com , the request will be sent with `source:My-Machine-IP`go to `Desntination:8.8.8.8` (Our first nameserver) on port `53` (defult port for dns) asking for ipv4 (A) for  google.com which will return as **142.250.200.238**

After understanding the whole high overview journey now,  lets return to scenario, We know can say the problem maybe :
- We hardcoded `google.com` to some IP in our /etc/hosts file
- Missing `dns` module in hosts line in `/etc/nnswitch`
- Wrong `nameserver`

> **NOTE** :
> In hosts line in `nsswitch.conf`. Every word is mapped to some module in operating system. So may be everything is Okay but the module is missing for some reason (actually i do not know if they could be missing or not but just for knowledge)

```bash
ali-mohamed@Ali-PC:~$ ls /lib/x86_64-linux-gnu/libnss_*.so*
/lib/x86_64-linux-gnu/libnss_compat.so
/lib/x86_64-linux-gnu/libnss_compat.so.2
/lib/x86_64-linux-gnu/libnss_dns.so.2  -----> dns
/lib/x86_64-linux-gnu/libnss_files.so.2 ----> files
/lib/x86_64-linux-gnu/libnss_hesiod.so
/lib/x86_64-linux-gnu/libnss_hesiod.so.2
/lib/x86_64-linux-gnu/libnss_mdns4_minimal.so.2
/lib/x86_64-linux-gnu/libnss_mdns4.so.2
/lib/x86_64-linux-gnu/libnss_mdns6_minimal.so.2
/lib/x86_64-linux-gnu/libnss_mdns6.so.2
/lib/x86_64-linux-gnu/libnss_mdns_minimal.so.2
/lib/x86_64-linux-gnu/libnss_mdns.so.2
/lib/x86_64-linux-gnu/libnss_sss.so.2
/lib/x86_64-linux-gnu/libnss_systemd.so.2
```

## systemd-resolved

Our Solution is correct in maybe a legacy server. Nowdays, there is `systemd-resolved`

> **Systemd-resolved** : It is a stub resolver used to run the DNS queries , managing resolv.conf , having cache , supporting mDNS , support split DNS, and other security staff (which I still do not get it) 

So by default now in servers contain systemd :
- `resolv.conf` is just a symbolic link to `/run/systemd/resolve/resolv.conf`. which sets the nameserver to **127.0.0.53** (where the systemd-resolver run) and set **search domains**.

The default content of `resolv.conf.

```bash
ali-mohamed@Ali-PC:~$ cat /etc/resolv.conf
# This is /run/systemd/resolve/stub-resolv.conf managed by man:systemd-resolved(8).
# Do not edit.
#
# This file might be symlinked as /etc/resolv.conf. If you're looking at
# /etc/resolv.conf and seeing this text, you have followed the symlink.
#
# This is a dynamic resolv.conf file for connecting local clients to the
# internal DNS stub resolver of systemd-resolved. This file lists all
# configured search domains.
#
# Run "resolvectl status" to see details about the uplink DNS servers
# currently in use.
#
# Third party programs should typically not access this file directly, but only
# through the symlink at /etc/resolv.conf. To manage man:resolv.conf(5) in a
# different way, replace this symlink by a static file or a different symlink.
#
# See man:systemd-resolved.service(8) for details about the supported modes of
# operation for /etc/resolv.conf.

nameserver 127.0.0.53
options edns0 trust-ad
search home

```


 so as stated `resolv.conf` is managed and written automatically by `systemd-resolver`.

But how that change our query path ?

from DNS module POV , actually nothing changes , nameserver will be found and qeury will be sent and setting wait for the answer. so even if it is `systemd-resolver` , Direct `dns server` or `a custom server` we build , DNS module did not care.

To get a view about what systemd-resolver do and its power , lets run resolvectl status :

```bash
ali-mohamed@Ali-PC:~$ resolvectl status
Global
  Protocols: -LLMNR -mDNS -DNSOverTLS DNSSEC=no/unsupported
  resolv.conf mode: stub

Link 2 (enp2s0)
    Current Scopes: none
    Protocols: -DefaultRoute -LLMNR -mDNS -DNSOverTLS DNSSEC=no/unsupported

Link 3 (wlo1)
    Current Scopes: DNS
    Protocols: +DefaultRoute -LLMNR -mDNS -DNSOverTLS DNSSEC=no/unsupported
Current DNS Server: 192.168.1.1
    DNS Servers: 192.168.1.1
    DNS Domain: home
```

What this says ?
- I have two interfaces on my device `enp2so` and `wlo1` (enp2so not found, it is none)
- **wl01** is configured with DNS server as **192.168.1.1**, so now any DNS query in this interface will go this IP 
> **NOTE**:  IT is easily noticed that 192.168.1.1 is my home router IP, systemd-resolver get this configs by DCHP when it first connected to this interface.

Lets see the new route on my Query :
```bash
02:39:16.536137 lo    In  IP 127.0.0.1.43730 > 127.0.0.53.53: 12383+ [1au] A? google.com. (39)
02:39:16.536349 wlo1  Out IP 192.168.1.8.52573 > 192.168.1.1.53: 2351+ A? google.com. (28)
02:39:16.570445 wlo1  In  IP 192.168.1.1.53 > 192.168.1.8.52573: 2351 1/0/0 A 142.250.201.14 (44)
02:39:16.570914 lo    In  IP 127.0.0.53.53 > 127.0.0.1.43730: 12383 1/0/1 A 142.250.201.14 (55)


```

Lets understand the output:  
- First, request will be send internally (the machine talk to itself), from  `127.0.0.1.43730` to `127.0.0.53.53` asking about the query. Here first power of systemd-resolver come which is caching. if systemd-resolver has entry for this query, it will send result back without any Out Request.
- If no entry found, request will send to our DNS server configured on the interface
- Finally , Result come back successfully.


Now , Lets make things more interesting, return back to the output of resolvectl. The new logic here that it is not just a static file like /etc/resolv.conf but the DNS settings are more dynamic and per interface. so every interface in our server or PC can have different settings now.

This can lead us to secodn power of systemd-resolver (**SPLIT DNS**) , Using Different interfaces for different domains.
Example:
  -  something.mycompany.com ----> 10.0.0.5 (my coperate VPN)
  - google.com ----> 192.168.1.1

 By configuring systemd-resolved as :

```
Global
    Protocols: -LLMNR -mDNS -DNSOverTLS DNSSEC=no/unsupported
    resolv.conf mode: stub
    
Link 2 (enp2s0)
    Current Scopes: none
    Protocols: -DefaultRoute -LLMNR -mDNS -DNSOverTLS DNSSEC=no/unsupported

Link 3 (wlo1)
    Current Scopes: DNS
    Protocols: +DefaultRoute -LLMNR -mDNS -DNSOverTLS DNSSEC=no/unsupported
    Current DNS Server: 192.168.1.1
    DNS Servers: 192.168.1.1
    DNS Domain: home
    
# mock configs
link 4 (vpn0)
	Current DNS Server: 10.0.0.5
    DNS Servers: 10.0.0.5
    DNS Domain: mycompany.com
```


Examples:  
- resolve **test.mycompany.com**
	1. query will routed to systemd-resolved
	2. it will try to match the domain (mycompany.com) to all interfaces servers
	3. Query matched to `vpn0` , so query will be sent to `10.0.0.5` (Done)

- resolve **test** 
	1. the host is not `FQDN` , then .home will be appended to it. (search field in resolv.conf)
	2. `test.home` will routed to systemd-resolved
	3. Trying to match the query 
	4. Send it to `wl01` server `192.168.1.1`

 - resolve **google.com**
	1. query will routed to systemd-resolved
	2. Trying to match the query 
	3. Send it to `wl01` server `192.168.1.1` , but why?  `wl01` is configured as default route (+DefaultRoute) if no domain is matched.


Okay, that is really good. But Lets manipulate things more and See important problem that could happen

```bash
# cat /etc/systemd/resolved.conf
[Resolve]
DNS=8.8.8.8

# Assume we configure  and run some custom DNS Server on 127.0.0.100
resolvectl domain wlo1 mycompany.com
resolvectl dns wl01 127.0.0.100
```

Now see resolvectl status again:

```
Global
         Protocols: -LLMNR -mDNS -DNSOverTLS DNSSEC=no/unsupported
  resolv.conf mode: stub
Current DNS Server: 8.8.8.8
       DNS Servers: 8.8.8.8 127.0.0.100

Link 3 (wl01)
    Current Scopes: DNS
         Protocols: +DefaultRoute -LLMNR -mDNS -DNSOverTLS DNSSEC=no/unsupported
Current DNS Server: 127.0.0.100
        DNS Servers: 127.0.0.100
        DNS Domain: mycompany.com
```

Also `resolv.conf` will still have the same stub server on `127.0.0.53` , but new search domains will reflected
```
ali-mohamed@Ali-PC:~$ cat /etc/resolv.conf

nameserver 127.0.0.53
options edns0 trust-ad
search mycompany.com
```


Now using one interface we also have split DNS, if we try to query something like **test.mycompany.com** , things going good we have ourQuery go to what we want. The Problem Is When we Query something like `google.com`

Even we will get our result back correctly. Two Queries will be send to `8.8.8.8` and `127.0.0.100` leading to **DNS LEAK**

Why Query go to 127.0.0.100 also ? 

As we stated before , when no Interface matched the query it will go to interfaces with **+DefaultRoute**, even define a global fallback DNS server will not overwrite that.

SEE THIS ISSUE ON GITHUB : [Systemd-resolved is silly](https://github.com/systemd/systemd/issues/33973)

So Configure Global DNS only in `resolved.conf` and imagine that we are good is a misconception. A solution to that is could be Either:
- Using `Domains=~.` when we configure our Global DNS server.
- Modify configs per interface using **network manager** and change it to `-DefaultRoute` (systemd-resolved do not do that automatically)

**TODO**

- Is this everything about DNS ?
- What is D-BUS ?
- Security Stuff
- Play with IPV6
- Dual Stack software examples 


# IPTABLES


There are servers that block **ICMP** , So ping them will fail.  How they do that? 
The Most popular answer is **Iptables**

> Iptables : it is a linux tool used to configure the kernel firewall, controlling which networks packets allowed or blocked and others things.

The Basic Idea behind Iptables are simple after understanding four concepts:
 - **TABLE** : logical Organization of rules (chains) , each one for a different purpose
	 - **filter** → default, used for allowing or blocking traffic
	 - **nat** → for network address translation (e.g., port forwarding)
	 - **mangle** → modify packet headers
	 - **raw** → control connection tracking
 - **CHAIN** : Each table has chains, which are group of rules that checked in order
 - **MATCH** : Every Rule specifie a match , which packets (eg: tcp  , udp), which hosts and what to do when match  (eg: target)
 - **TARGET** : The Action Done on the match packet

>NOTE: There is a default policy on every chain. if no rule match. the default policy will be applied.

There are a lot we can do by these concepts, the default ones or custom ones we build. we can reject packet and allow others, redirect from destination to another, Rate limiting per IP , even we can make our machine a load balancer (limited due to static IPs). This photo shows the order of all default chains :
![[Attachments/Pasted image 20260205213002.png]]
Some Iptables commands Examples:

```bash
# Example: Redirect all requests comes for outside on localhost:80 to  localhost:8080
sudo iptables \
--table nat \ 
--append PREROUTING \#append to PREROUTING chain
--protocol tcp \# match
--destination 127.0.0.1 \# match
--dport 80 \# match
--jump REDIRECT \# Target
--to-port 8080 \# Action


# Drop echo requests (ping)
sudo iptables \
--table filter \
--append INPUT \
--protocol icmp \
--icmp-type echo-request \
--jump DROP

# Redirect all incoming requests to our server to 10.0.0.25 server

# STEP 1
sudo iptables \
--table nat \
--append PREROUTING \
--protocol tcp \
--destination 192.168.1.10 \
--dport 80 \
--jump DNAT \
--to-destination 10.0.0.25:8080

# STEP2 : send the packets to our server again. client server does not know anything about 10.0.0.25 
sudo iptables \
--table nat \
--append POSTROUTING \
--source 10.0.0.25 \
--protocol tcp \
--sport 8080 \
# option 1 : static IP
--jump SNAT \
--to-source 192.168.1.10 
# option 2 : dynamic IP
--jump MASQUERADE
--
```


make sure to enable IP Forwarding
```bash

sudo sysctl -w net.ipv4.ip_forward=1
```


There are a lot to do by `NAT` table and others which can be found:
 - [Iptables- a beast worth training](https://dev.to/netikras/iptables-a-beast-worth-training-a-firewall-a-nat-router-a-port-forwarder-an-lb-anti-dos-a-logger-for-free-5157)
 - [Iptables- a comprehensive guide](https://sudamtm.medium.com/iptables-a-comprehensive-guide-276b8604eff1)
 - [Iptables-linux](https://phoenixnap.com/kb/iptables-linux)
 - [Hussien Nasser: Port redirection and Forwarding](https://youtu.be/NAdJojxENEU?si=kUrUFgB3WP3jfAa_)
 - [Hussien Nasser: Load Balancing](https://youtu.be/-CraNvj48J0?si=RgvabfGA17wDzqjG)

Docker use Iptables heavily (`NAT` and `filter`) . so how that works and some common gotcha

```
# Create nginx container listen on port 9090
ali-mohamed@Ali-PC:~$ docker run --name a1-nginx -p 9090:80 -d nginx
5512e613ac94066619e502d652eff981dc401d7761d1e162cc30ee6d367f7405

```

Docker create some chains , lets know about them while follow the path of an incoming request to our nginx (assume new connection and focusing only on nat and filter tables):

```bash

# NAT table chains
ali-mohamed@Ali-PC:~$ sudo iptables -t nat -L -n
Chain PREROUTING (policy ACCEPT)
target     prot opt source               destination         
DOCKER     0    --  0.0.0.0/0            0.0.0.0/0            ADDRTYPE match dst-type LOCAL

Chain INPUT (policy ACCEPT)
target     prot opt source               destination         

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination         
DOCKER     0    --  0.0.0.0/0           !127.0.0.0/8          ADDRTYPE match dst-type LOCAL

Chain POSTROUTING (policy ACCEPT)
target     prot opt source               destination         
MASQUERADE  0    --  172.17.0.0/16        0.0.0.0/0                   
MASQUERADE  0    --  192.168.16.0/20      0.0.0.0/0                     
MASQUERADE  0    --  192.168.32.0/20      0.0.0.0/0           
        

Chain DOCKER (2 references)
target     prot opt source               destination         
DNAT       6    --  0.0.0.0/0            0.0.0.0/0            tcp dpt:9090 to:172.17.0.2:80

```

- the packet will go through `PREROUTING` chain that will forward all packets to `DOCKER` chain (Created by Docker)
- Now in `DOCKER` chain there is rule accepts requests from all interfaces and replace their destination from whatever to `172.17.0.2:80` which is the container ip in docker network

```bash
# FILTER table chains
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         

Chain FORWARD (policy DROP)
target     prot opt source               destination         
DOCKER-USER  0    --  0.0.0.0/0            0.0.0.0/0           
DOCKER-FORWARD  0    --  0.0.0.0/0            0.0.0.0/0           

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination         

Chain DOCKER (15 references)
target     prot opt source               destination         
ACCEPT     6    --  0.0.0.0/0            172.17.0.2           tcp dpt:80
DROP       0    --  0.0.0.0/0            0.0.0.0/0           
         

Chain DOCKER-BRIDGE (1 references)
target     prot opt source               destination         
DOCKER     0    --  0.0.0.0/0            0.0.0.0/0           
          

Chain DOCKER-CT (1 references)
target     prot opt source               destination         
ACCEPT     0    --  0.0.0.0/0            0.0.0.0/0            ctstate RELATED,ESTABLISHED


Chain DOCKER-FORWARD (1 references)
target     prot opt source               destination         
DOCKER-CT  0    --  0.0.0.0/0            0.0.0.0/0           
DOCKER-INTERNAL  0    --  0.0.0.0/0            0.0.0.0/0           
DOCKER-BRIDGE  0    --  0.0.0.0/0            0.0.0.0/0           
ACCEPT     0    --  0.0.0.0/0            0.0.0.0/0                    

Chain DOCKER-INTERNAL (1 references)
target     prot opt source               destination         

Chain DOCKER-USER (1 references)
target     prot opt source               destination  
```

- Now packet will path through `FORWARD` chain that will route to `DOCKER-USER` chain (empty now) then go to second chain `DOCKER-FORWARD` 
- in `Docker-FORWARD` , packet will be routed to `DOCKER-CT` which will accept any already established connection (not our case) , then `DOCKER-INTERNAL` (empty for now) , Finally `DOCKER` chain where we fill find a rule to accept the packets from `172.17.0.2` 
- Kernel forward packets from the host interface to docker interface `docker0`
```bash
11: docker0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    link/ether ea:d9:a6:3c:ff:9d brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
       valid_lft forever preferred_lft forever
    inet6 fe80::e8d9:a6ff:fe3c:ff9d/64 scope link 
       valid_lft forever preferred_lft forever
```
- container receives the packet, do logic and send response back
-  Finally, It is time for `POSTROUTING` chain , that will change the contianer ip `172.0.0.2` to our host Ip

Okay, After understanding Iptables , these words are like a game but there is two gotachs to take care of them here
- **NO INPUT CHAIN** : the normal way to block access is  to add rule in filter Input chain but as we see the packets related to docker do not path through them because the ip already mapped by DNAT in Docker Chain of `NAT` Table
```bash
# DO NOT
iptables -A INPUT -p tcp --dport 443 -s 172.16.0.0/26 -m state --state NEW,ESTABLISHED
```

Instead as said in Docker Docs, use `Docker-USER`  To add any filter rules related to containers

- **Any port exposed is public**: Even with firewalls configured as we can see Docker manipulate these a lot , so having firewall that block everything instead port `443` will not prevent public access to our nginx container on `9090`. Do not assume default things , see the path and order of rules. we can expose the port only internally by `-p 127.0.0.1:9999:80` 
```bash
ali-mohamed@Ali-PC:~$ docker run --name a2-nginx -p 127.0.0.1:9999:80 -d nginx
4f723f84bb10345020a2aca47066b042ced4db9086114222c0a5c0c568835492

# NAT
Chain DOCKER (2 references)
target     prot opt source               destination         
DNAT       6    --  0.0.0.0/0            0.0.0.0/0            tcp dpt:9090 to:172.17.0.2:80
DNAT       6    --  0.0.0.0/0            127.0.0.1            tcp dpt:9999 to:172.17.0.3:80

```

by this way we can only access our container from our host, but to be able to do that we can put reverse proxy on the edge with our auth and configure routes in it to our containers

Read This, they are outdated but good :
- [IPTables and Docker](https://medium.com/@ebuschini/iptables-and-docker-95e2496f0b45)
- [IPTables and Docke Gist](https://gist.github.com/viperey/d5598e49e0c2a90760e036f70fa79cfb)

**TODO**
- Use Firewalls like ufw or firewalld
- use `nfttables` (iptables new version)



# SSH

This photo is more than enough for now.
![[Attachments/Pasted image 20260205213115.png]]
 *source : [SSH Tunnels](https://iximiuz.com/en/posts/ssh-tunnels/)*
 
Resources :
 - [Understanding the SSH Encryption and Connection Process](https://www.digitalocean.com/community/tutorials/understanding-the-ssh-encryption-and-connection-process)
 - [SSH Tunnels](https://iximiuz.com/en/posts/ssh-tunnels/)
