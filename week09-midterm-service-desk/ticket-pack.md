# Ticket Pack - CVNP1606 Week 09 Midterm Service Desk Surge

Ticket CVNP1606-W09-009

## Prioritization

I read all four tickets before opening any tools and ranked them by their potential for negative business impact. Ticket A is at the top of this list because the locked cashier account will prevent the entire shift from starting, affecting the most employees and limiting store operations until the issue is resolved. Ticket D comes next, as Marcus will not be able to perform any duties and has onboarding documents that must be completed by the end of the day. Without connectivity via his workstation, I can't apply or validate fixes to that machine, which requires an expedited diagnosis and escalation to allow time to resolve. Ticket C is next because Emily has a video conference in two hours; she can continue the remainder of her tasks without audio. Ticket B is last in my evaluation process because Alex's workstation is slow but functional, affects only one employee, and has no deadlines associated with resolving the issue.

## Ticket A - Account Lockout

Action Taken - Account Confirmation:
I checked whether or not the cashier account acme-pos-cashier01 had been locked out by looking at its account state. It said that Lockout = True. I removed the lockout from the account. This put the account back into a working state, enabled, without changing the password. I also reviewed the security logs to filter all of the related events about the lockouts and failed logins to determine why this occurred.

Event Ids Found:
The two event ids were:
Event id 4740 - A user account was locked out.
Event id 4625 - An account failed to log in.
Both referenced the same target account name, acme-pos-cashier01. Repeated 4625 failed login attempts resulted in the account being placed beyond the lockout threshold causing the event id 4740 to be generated.

Account Restoration Confirmation Process:
After removing the lockout, I checked the account state again to see if Lockout was now False; it was. Additionally, I verified that the account was enabled. Therefore, the cashier is able to log in and begin their shift.

## Ticket B - Slow Workstation

Tools used: Task Manager, Task Scheduler, and Windows PowerShell.
Prior to: Using Task Manager's Processes, sorted by CPU, there was a background Windows PowerShell Process identified as consuming extremely high amounts of CPU and Memory; the Startup apps view and Task Scheduler revealed that the task CVNP1606_CloudSyncAgent was configured to automatically start at Log On, which initiated this PowerShell Process. This matches the described behavior of the workstation slowing down for approximately one week, during which the user was unaware of the changes made to the Workstation.
Action proposed: end and disable the CVNP1606_CloudSyncAgent scheduled task so it no longer initiates the background process at logon, then check processes again.
Post: After disabling the task, Task Manager's Processes showed no processes using extreme amounts of CPU and memory when sorted by CPU. CPU & memory utilization dropped, and the scheduled task that started it was disabled. The Workstation returned to its pre-slowdown state.

## Ticket C - Driver Failure

I used Device Manager and Windows PowerShell in the Administrator Session.
My investigation showed the audio device had a yellow Warning symbol in Device Manager under Other devices, and its General Tab listed, The drivers for this device are not installed. This was indicated by Error Code 28. Additionally, the ticket indicated that audio stopped working after a Windows Update ran overnight.
Actions taken included checking Roll Back Driver on the Driver tab; however, Roll Back Driver had no effect when clicked because no prior driver version existed to roll back to. Because the roll-back had no effect, I uninstalled the Audio Device. I ran a hardware change scan, which allowed Windows to reinstall the audio driver from the local driver store. There was no need to download additional software since the working driver package was already present on the computer.
I have validated that my solution resolved the issue through my verification process. I confirmed the resolution by verifying that the device was now reporting as working properly in Device Manager under Sound, video and game controllers, with no error codes.

The full change note is in change-note.md.

## Ticket D - Network Connectivity

The tool utilized was Windows PowerShell along with the built-in networking commands: ipconfig, ping, and Test-NetConnection.
I discovered through running ipconfig /all that there was an assigned IP address and Subnet Mask associated with the workstation; however, the Default Gateway was not responding as required, and the DNS server addresses were unable to be reached on the current network.
The four-layered ping sequence identified the point of failure. A successful loopback test to 127.0.0.1 proved that the TCP/IP Stack functionally works. A successful local IP test to the workstation's address also proved that the workstation's network adapter is correctly bound and functioning. An unsuccessful gateway test confirmed that the local network path to the gateway was lost. An unsuccessful test to the external IP address 8.8.8.8 was also expected due to loss of gateway access. Test-NetConnection to Port 445 was also unable to establish a connection which is consistent with loss of the network path versus loss of a specific service.
At which layer did the failure occur and what is its implications?: The failure occurred at the Gateway Layer. Both layers of the stack, the stack itself and the adapter, appear to be working properly, therefore this is not a hardware or driver issue on the workstation level. The Gateway/DNS settings provided are incorrect for this network therefore indicate an incorrect configuration of the workstation's IP settings versus a physical problem.
This ticket has been escalated. To resolve this issue will require modification of the workstation's network configuration by the Networking Team and thus my role here is to diagnose and document and NOT modify the workstation.

User Instructions for Marcus:
Marcus, I researched why your workstation can't access our shared drives or other internal websites. Your workstation's networking issues are not due to the workstation itself; it is functioning properly. However, because your workstation is using incorrect network settings, you can't access our systems.
I forwarded all necessary information to our Network Team, who will update your workstation settings; no action is required from you. Since you are due to submit your onboarding documents today, I have prioritized this issue. Once the Network Team adjusts your workstation settings, your ability to connect to the sites should be restored automatically. Once connectivity resumes, I will follow up with you via email to confirm this status, and then you may submit your onboarding documentation.