**CVNP 1606 Week 01 Build Sheet**



**Scenario**

You are a junior technician at Nexus Support Services. ACME is refreshing branch-office endpoints, and your lead needs one clean Windows 11 VM baseline that can be reused for later troubleshooting labs. Your job is to build the endpoint, verify the baseline state, capture evidence, and document the setup so another technician could repeat it.



**Ticket**

Ticket ID	CVNP1606-W01-001

Submitted by	Jordan Lee, Nexus Support Services Lead Technician

Affected system	ACME-W11-BASELINE

Request	Build a clean Windows 11 endpoint baseline with inventory evidence and snapshot documentation.

Business impact	Medium - later labs depend on a stable starting image.

Initial evidence	No reusable Windows 11 student baseline exists yet.

Required outcome	A bootable Windows 11 VM with admin and standard test accounts, update evidence, inventory output, and a clean baseline snapshot.



**Tools utilized**

Hypervisor: Proxmox VE on a Dell PowerEdge R320

Guest OS: Windows 11 Enterprise Evaluation build 26200. 

VM firmware: UEFI with Secure Boot enabled and virtual TPM 2.0

VM hardware: 6 vcpu, QEMU Standard pc (Q35 + ICH9), Proxmox EDK II bios

Shell: windows powershell 5.1 and PowerShell ISE, run as administrator

Version control: git for windows; repository Chris-cvnp/cvnp1606-porftolio



**Steps taken**

Vm provisioning: Vm 101 (cvnp1606-lab-win11) is running under proxmox VE using uefi firmware, Secure Boot has been enabled, and there is a virtual TPM 2.0. three requirements must be met to enable windows 11. Verified through msinfo32 after installation.

Accounts: The machine has one administrator account and one test user account (test). Verified the type of account through Get-LocalGroupMember against both the Administrators group and Users groups, so the evidence shows direct membership in these groups.

Windows updates: Completed windows update to verify the machine had no pending updates prior to creating baseline snapshot.

System inventory: From week01-build-sheet folder: get-computerinfo | Select-Object CsName, windowsproductname, OsVersion, biosfirmwaretype | Out-File inventory.txt

Baseline snapshot: Created proxmox snapshot w01\_cleandbaseline at 17:07:55 on 2026-08-27. The baseline shows a finished state because accounts and updates were completed before creation. It has an earlier snapshot, providing two rollback points.

Evidence collection: Copied collect-evidence.ps1 from course materials into week01-build-sheet and executed it as administrator. Generated evidence-report.txt showing zero not found entries.

Submission: Committed all deliverables and pushed to portfolio repository.





**Evidence List**

* VM hardware summary and Windows edition (VM Hardware (msinfo32).png)
* Account setup, admin and standard test account (Accounts.png)
* Windows Update status (Windows Update.png)
* Inventory command and output (Inventory.png)
* W01\_CleanBaseline snapshot with timestamp (Snapshot.png)
* VM hardware configuration in Proxmox (VM Hardware Proxmox.png)
* inventory.txt
* evidence-report.txt, all required files show FOUND







**Troubleshooting Narrative**



**What went wrong? Or what could realistically have gone wrong?**



Before I watched the lecture provided by my instructor, I started working on my project. During the process, I encountered problems with an administrator account. Ultimately, I ended up having two user profile folders under the same account name. Also, I was unable to change directories correctly or write files to the folders I needed.





**What evidence did you check first?**



First I looked at the accounts to determine whether I had administrator privileges, in order to understand why I was unable to build my portfolio correctly.





**What did you try?**



I tried switching between accounts, but with the profiles carrying the same name, I was not able to build out until I removed the unwanted profile with files already in it.





**What fixed it, or what would you try next?**



After enabling a second administrator account so that I could remove the unwanted profile, I was able to make the account I wanted the working administrator account.





**How did you verify the result?**



I checked the directory to verify the account, and then I started building the files I needed. Once I was able to successfully build, I knew I had corrected the issue, and things became a lot easier.





**What was the support or security impact of the issue or fix?**



Work production will be impacted by this type of issue. Not being able to write documents to a directory or create the folders needed will significantly impact productivity. I would not claim that it is a significant problem, but it would be a major inconvenience until it has been corrected.





**AI Disclosure**



I used AI to give me prompts and help format this document. Being that this is my first lesson, I was unsure of exactly what to put in it or how to write it. I asked the AI to give me prompts and ask me questions to be able to complete this writing. I also asked for cmdlets when I was trying to remove the duplicate user profile, and I asked it about a file's contents when I was not getting the same data in my file as my instructor, even though I was following the lecture.



I built the VM myself, as well as setting up the user accounts. I ran Windows Update to get Windows up to date. I took screenshots of my work to document what I had done as well as the progress I was making. Even though I used AI prompts to structure this README, every word typed is my own.



Generally, I tell the AI to search online for multiple verifiable sources when I ask it to do something, especially when it comes to running commands. I also ask it for its sources, and sometimes I ask it for the URL of where it found the information so that I can read it myself.



I asked the AI to help me figure out what I had done wrong and why my output was not matching what I was seeing in the lecture from my instructor. It told me that my instructor had done something wrong. I knew that was absolutely false because my instructor had the correct data in his file and I did not. It turns out I was not clicking in the correct spot, and my information was correct and matched my instructor's.





**What I Can Do Now**



I built a Windows 11 virtual machine, verified it was up to date and had both an administrator account and a standard test account, and captured a known-good baseline snapshot that can be restored if the machine crashes or fails. This is the same work an IT technician does when standing up VMs or provisioning new desktops and laptops for employees.

