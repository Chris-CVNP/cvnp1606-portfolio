# AI Validation

## What I asked the AI to help with

I used Claude to assist with this lab. I asked it for the PowerShell commands to set and restore the DNS server, since the assignment did not include them. I also asked it to explain command output when I got a result I did not expect, and it gave me drafts that I rewrote in my own words.

## What I verified on the live VM

I ran every command myself on my Windows 11 VM and checked each result against the real output. ipconfig /all showed DNS Servers as 1.2.3.4 and nslookup acme.internal timed out, which confirmed the fault. After I restored the DNS server, nslookup got an answer from 10.10.50.1 and Resolve-DnsName www.microsoft.com returned address records, which confirmed the fix.

## One suggestion I accepted, revised, or rejected

Revised. The first command the AI gave me to change the DNS server had a placeholder where the adapter name belonged, and it failed with a wildcard pattern error. I ran Get-NetAdapter, saw the real adapter name was Ethernet, and the command was corrected to use it. AI commands have to be checked against the real system before they are trusted.