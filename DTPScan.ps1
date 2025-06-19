# DTPScan.ps1 - PowerShell Port
# Original by Daniel Compton | Converted by ChatGPT for Windows
# https://www.commonexploits.com

$DTPSEC = 90
$VERSION = "1.3"

Clear-Host
Write-Host "########################################################" -ForegroundColor Green
Write-Host "***   DTPScan - The VLAN DTP Scanner $VERSION  ***"
Write-Host "***   Detects DTP modes for VLAN Hopping (Passive) ***"
Write-Host "########################################################" -ForegroundColor Green

# Check if tshark is installed
if (-not (Get-Command tshark -ErrorAction SilentlyContinue)) {
    Write-Host "[!] Unable to find the required 'tshark' program. Install it and try again." -ForegroundColor Red
    exit 1
}

# List available interfaces
Write-Host "`n[-] The following Interfaces are available`n" -ForegroundColor Green
$tsharkInterfaces = tshark -D
$tsharkInterfaces | ForEach-Object { Write-Host $_ }

# Prompt user for interface
Write-Host "`n----------------------------------------------------------" -ForegroundColor Red
$INT = Read-Host "[?] Enter the interface number to scan from (e.g. 1, 2...)"
Write-Host "----------------------------------------------------------" -ForegroundColor Red

if (-not ($tsharkInterfaces -match "^\d+\.\s.*$" | Where-Object { $_ -match "^$INT\." })) {
    Write-Host "[!] Sorry, the interface you entered does not exist!" -ForegroundColor Red
    exit 1
}

Write-Host "`n[-] Now sniffing DTP packets on interface $INT for $DTPSEC seconds...`n" -ForegroundColor Green
tshark -a duration:$DTPSEC -i $INT -Y "dtp" -x -V > dtp.tmp 2>&1

$COUNTDTP = (Select-String -Path dtp.tmp -Pattern "dtp").Count
if ($COUNTDTP -eq 0) {
    Write-Host "`n[!] No DTP packets were found. DTP is probably disabled." -ForegroundColor Red
    Write-Host "[!] DTP VLAN attacks will not be possible from this port." -ForegroundColor Red
    Write-Host "[-] Note: This is port specific and doesn't reflect all ports on the device." -ForegroundColor Yellow
    Remove-Item dtp.tmp -ErrorAction SilentlyContinue
    exit 0
}

$DTPMODE = Select-String -Path dtp.tmp -Pattern "Status: 0x" | 
    ForEach-Object { ($_ -split "Status: ")[1].Trim() } |
    Sort-Object -Unique |
    Select-Object -First 1

switch ($DTPMODE) {
    "0x03" {
        Write-Host "`n[+] DTP in default 'Auto' mode. VLAN hopping possible." -ForegroundColor Green
    }
    "0x83" {
        Write-Host "`n[+] DTP in 'dynamic desirable' mode. VLAN hopping should be possible." -ForegroundColor Green
    }
    "0x04" {
        Write-Host "`n[+] DTP in 'dynamic desirable' mode. VLAN hopping should be possible." -ForegroundColor Green
    }
    "0x81" {
        Write-Host "`n[+] DTP in 'trunk' mode. VLAN attacks not possible." -ForegroundColor Red
    }
    "0xa5" {
        Write-Host "`n[+] DTP in 'trunk 802.1Q' mode. VLAN attacks not possible." -ForegroundColor Red
    }
    "0x42" {
        Write-Host "`n[+] DTP in 'trunk ISL' mode. VLAN attacks not possible." -ForegroundColor Red
    }
    "0x84" {
        Write-Host "`n[+] DTP in 'dynamic auto' mode. VLAN hopping should be possible." -ForegroundColor Green
    }
    "0x02" {
        Write-Host "`n[+] DTP in 'access' mode. VLAN attacks not possible." -ForegroundColor Red
    }
    Default {
        Write-Host "`n[?] Unknown DTP status: $DTPMODE" -ForegroundColor Yellow
    }
}

Remove-Item dtp.tmp -ErrorAction SilentlyContinue
exit 0
