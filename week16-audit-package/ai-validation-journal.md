Week 06, 2026-10-02: Network Connectivity Fault, ticket CVNP1606-W06-006
Asked: I asked the AI to put the lab steps in order and give me the PowerShell commands to set the DNS server to an invalid address and restore it, since the assignment did not include them.
Verified: On my Windows 11 VM I confirmed the fault with ipconfig /all showing DNS Servers 1.2.3.4 and nslookup acme.internal timing out. After the fix I confirmed with nslookup and Resolve-DnsName that the server at 10.10.50.1 answered.
Accept/revise/reject: Revised. The first DNS command the AI gave me had a placeholder where the adapter name belonged, and it failed with a wildcard pattern error. I ran Get-NetAdapter, found the real adapter name was Ethernet, and corrected the command before running it again.

Week 09, 2026-10-25: Service Desk Surge, four-ticket triage
Asked: I asked the AI to help me triage four tickets on my lab VM, an account lockout, a slow workstation, a failed audio driver, and a network failure, and to get the instructor's lab files onto the VM.
Verified: I confirmed each fault on the VM before documenting it, and I checked the instructor's follow-up email against what I had been setting up.
Accept/revise/reject: Rejected. The AI kept working toward importing a large instructor VMware VM, including resizing my VM disk and enabling nested virtualization. The instructor's email showed the lab only needed a small script bundle that seeds the faults directly on my VM, so I dropped the VM import path and used the scripts.

Week 10, 2026-11-03: Intune and Entra Onboarding, ticket CVNP1606-W10-010
Asked: I asked the AI to walk me through the Tenant Setup Guide and then analyze the instructor-provided enrollment evidence after my own tenant verification was denied.
Verified: I checked the dsregcmd /status capture, which showed AzureAdJoined YES with a blank MdmUrl, and the Intune All devices entry for the test device.
Accept/revise/reject: Rejected. The AI's first tenant setup steps came from a blog and Microsoft Learn instead of the Tenant Setup Guide. It added steps the guide did not list and left out assigning the Intune license. I had it audit its steps against the guide line by line and followed the guide's sequence instead.

Week 16, 2026-11-22: Final MSP Audit Package, ticket CVNP1606-W16-016
Asked: I asked the AI to help me build health-report.ps1 and pick three ticket-evidence artifacts from my portfolio.
Verified: I ran health-report.ps1 as administrator on my VM and confirmed with Get-Content that health-report-output.txt showed all seven sections, including BitLocker Protection On and the five most recent error events.
Accept/revise/reject: Accepted. The AI picked event-timeline.md from Week 8, the pilot ring settings screenshot from Week 15, and bitlocker-sop.md from Week 14. I accepted them after confirming each file was already committed in my repo and copied into ticket-evidence without errors.

STAR answer: a time AI was wrong and how I caught it
Situation: In the Week 8 desk discussion on Ticket #3388, about Register 3 at Store 4, I was the senior tech reviewing a classmate's post.
Task: I had to sign off on the citation or escalate it back.
Action: The classmate's SOURCE quoted a notebook AI chat response instead of a document. I searched the ACME documents and the lecture script, and that line was not in any of them. I escalated back and pointed to the passages that did support the answer: lecture_script.md, M1 Event Log Vocabulary, which says no Event 1074 before a reboot rules out Windows Update, and acme-branch-network-map.md, rev. 2026-03, Site notes for Store 4, which says the UPS for Register 3 was flagged in February as past its battery service life and has not been replaced.
Result: The AI's answer happened to land on the right call but had no real source behind it. The documents settled it, and the post could be fixed with a citation anyone can check.