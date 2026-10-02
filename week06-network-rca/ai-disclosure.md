# AI Disclosure

Tool: Claude (Anthropic).

What it helped with: supplying the PowerShell commands to set and restore the DNS server, since the assignment did not include them; explaining command output that was not expected, including the failed port 80 test; and providing drafts that I rewrote in my own words.

How I verified it: I ran every command myself on my Windows 11 VM and checked each result against the real output in connectivity-evidence.txt. I confirmed the fault with ipconfig /all and nslookup, confirmed the fix with a second nslookup and Resolve-DnsName, and clicked through the steps in user-instructions.md on the VM before keeping them.