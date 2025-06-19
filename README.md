Understood. Here's the complete `README.md` content — **no formatting, no split** — just copy and paste it as-is:

````markdown
# DTPScan (PowerShell Port for Windows)

**DTPScan** is a Windows PowerShell port of the original Bash-based VLAN DTP scanner by Daniel Compton. It passively listens for Dynamic Trunking Protocol (DTP) packets to detect VLAN hopping vulnerabilities on Cisco switches.

This version works entirely on Windows and uses `tshark` (included with Wireshark) for packet sniffing.

---

## ⚡ Features

- Sniffs DTP traffic to identify trunking mode
- Detects `auto`, `desirable`, `trunk`, `access`, and other common DTP states
- Fully passive — no packets are sent
- CLI-only, suitable for security assessments and red team labs

---

## 🛠 Requirements

- **Wireshark** installed with `tshark` (CLI capture tool)
- PowerShell (tested on Windows 10/11 with PowerShell 5.1+)
- Admin privileges (to capture packets from interfaces)

---

## 🔧 Installation

1. Install [Wireshark](https://www.wireshark.org/download.html)
   - Ensure you check **"Install TShark"** during setup
   - Also install **Npcap** when prompted

2. Add Wireshark to your system `PATH`:
   - Add this to your `PATH` if not already:
     ```
     C:\Program Files\Wireshark
     ```

3. Clone this repository:
   ```powershell
   git clone https://github.com/SwampSec/dtpscan-windows.git
   cd dtpscan-windows
   ```

---

## 🚀 Usage

1. Open **PowerShell as Administrator**
2. Run the script:
   ```powershell
   .\DTPScan.ps1
   ```
3. When prompted, choose the correct interface number (you can run `tshark -D` to list them ahead of time)

---

## 📡 Example Output

```
[+] DTP was found enabled in mode 'switchport mode dynamic desirable'.
[+] VLAN hopping should be possible.
```

If DTP is not detected:
```
[!] No DTP packets were found. DTP is probably disabled and in 'switchport nonegotiate' mode.
```

---

## ✅ DTP Mode Codes Detected

| DTP Mode Code | Meaning                                      | VLAN Hopping?        |
|---------------|----------------------------------------------|-----------------------|
| 0x03          | Dynamic Auto (default)                       | ✅ Possible           |
| 0x83 / 0x04   | Dynamic Desirable                            | ✅ Possible           |
| 0x84          | Dynamic Auto                                 | ✅ Possible           |
| 0x81          | Trunk                                        | ❌ Not Possible       |
| 0x02          | Access                                       | ❌ Not Possible       |
| 0xa5          | Trunk (802.1Q encapsulation forced)          | ❌ Not Possible       |
| 0x42          | Trunk (ISL encapsulation forced)             | ❌ Not Possible       |

---

## 🧪 Notes

- This script **only tests the port you're connected to**
- Just because one port blocks DTP doesn't mean others do
- Useful in red team or lab environments to validate switch misconfigurations

---

## 🔒 Legal Disclaimer

This tool is intended for **educational and authorized security testing** purposes only.  
**Unauthorized use on networks you do not own or have permission to test is strictly prohibited.**

---

## 🙏 Credit

- Original Bash Script by: [Daniel Compton](https://www.commonexploits.com)
- PowerShell Port by: [SwampSec](https://github.com/SwampSec)
````

Paste that directly into your `README.md` file. You're good to go.
