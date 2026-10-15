# Task 1 – Basic Network Scanning with Nmap

Scan a **local virtual machine** with Nmap, identify open ports and services, and analyse the security risk of each one.

> ⚠️ **Ethics note:** Only scan machines you own or have explicit written permission to scan. This project uses a local VM on an isolated network. Never scan external or production systems.

---

## 1. What is Nmap?

**Nmap** (Network Mapper) is a free, open-source tool for network discovery and security auditing. It sends specially crafted packets to a target and analyses the replies to determine:

- which hosts are up
- which **ports** are open, closed or filtered
- which **services and versions** are listening on those ports
- which **operating system** the host is probably running

## 2. Why does network scanning matter?

- **See your attack surface.** Every open port is a possible entry point. You can't protect what you don't know exists.
- **Find unneeded services.** Old FTP, Telnet or database ports exposed by mistake are common causes of breaches.
- **Spot outdated software.** Version detection shows services that may have known vulnerabilities (CVEs).
- **Verify firewall rules.** Confirms that only intended ports are reachable.
- **Support compliance and audits** (e.g., PCI-DSS, ISO 27001 require regular scanning).

## 3. Ethical use guidelines

1. Scan only systems you **own** or have **explicit written permission** for.
2. Use an isolated lab (VirtualBox host-only or NAT network).
3. Never scan public IPs, university/company networks, or cloud systems without authorisation.
4. Unauthorised scanning may be illegal (e.g., the Computer Fraud and Abuse Act in the US, the IT Act 2000 in India).
5. Keep scan results confidential and report findings responsibly.

---

## 4. Lab setup

| Item | Value |
|------|-------|
| Hypervisor | VirtualBox |
| Attacker machine | Kali Linux (or host OS) |
| Target machine | Ubuntu Server VM (your own) |
| Network mode | Host-only adapter (e.g., `192.168.56.0/24`) |
| Target IP | Find with `ip a` on the target VM |

To make the scan interesting, install a few services on the **target** VM:

```bash
sudo apt update
sudo apt install -y openssh-server apache2 vsftpd mariadb-server
```

## 5. Installing Nmap

**Kali Linux:** preinstalled. Check with `nmap --version`.

**Ubuntu / Debian:**
```bash
sudo apt update
sudo apt install -y nmap
nmap --version
```

**Windows:** download the installer from <https://nmap.org/download.html>, run it (accept Npcap), then open PowerShell and run `nmap --version`.

**macOS:** `brew install nmap`

## 6. Running the scans

Replace `TARGET` with your VM's IP (e.g., `192.168.56.101`).

| Step | Command | Purpose |
|------|---------|---------|
| 1. Basic scan | `nmap TARGET` | Top 1000 TCP ports |
| 2. Service version scan | `nmap -sV TARGET` | Identify service names and versions |
| 3. OS detection | `sudo nmap -O TARGET` | Guess the operating system (needs root) |

Or run everything automatically:

```bash
chmod +x run_scans.sh
./run_scans.sh 192.168.56.101
```

This saves raw output into the `scan_output/` folder.

## 7. Screenshots

Take a screenshot of each terminal output and save it in `screenshots/`:

- `01_nmap_basic.png`
- `02_nmap_sV.png`
- `03_nmap_O.png`

## 8. Findings summary

See **`nmap_scan_results.txt`** for full results and per-port analysis.

| Port | Service | Version | Risk |
|------|---------|---------|------|
| 21/tcp | FTP | vsftpd | 🔴 High – plaintext credentials |
| 22/tcp | SSH | OpenSSH | 🟡 Medium – brute-force target if poorly configured |
| 80/tcp | HTTP | Apache httpd | 🟡 Medium – web attack surface, no encryption |
| 3306/tcp | MySQL/MariaDB | MariaDB | 🔴 High if exposed beyond localhost |

*(Update this table with your real results.)*

## 9. Repository structure

```
nmap-network-scan/
├── README.md
├── nmap_scan_results.txt
├── run_scans.sh
└── screenshots/
    ├── 01_nmap_basic.png
    ├── 02_nmap_sV.png
    └── 03_nmap_O.png
```

## 10. Key takeaways / hardening

- Disable services you don't need.
- Replace FTP with SFTP; use HTTPS instead of HTTP.
- Bind databases to `127.0.0.1` and firewall port 3306.
- SSH: key-based login, disable root login, use fail2ban.
- Enable a firewall (`sudo ufw enable`) and allow only required ports.
- Patch regularly.
