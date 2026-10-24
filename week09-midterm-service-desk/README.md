# CVNP1606 Week 09 Midterm: Service Desk Surge

Ticket CVNP1606-W09-009 - Work a four ticket mixed Windows support queue, prioritize by business impact, and resolve or escalate each ticket with documented evidence.

Author: C A

## Objectives

- Read all four tickets and prioritize the queue by business impact before opening any tool
- Unlock the account and confirm the lockout in the Event Viewer Security log
- Identify the top resource consumer on the slow workstation with Task Manager and Resource Monitor
- Identify and recover the failed audio device with Device Manager and write a change note
- Diagnose the network fault with ipconfig, a four layer ping sequence, and Test-NetConnection, then escalate
- Run collect-evidence.ps1 and confirm all required files show FOUND

## Tools Used

- Event Viewer Security log
- Task Manager and Resource Monitor
- Task Scheduler
- Device Manager
- ipconfig /all
- ping
- Test-NetConnection
- collect-evidence.ps1

## Configuration

Ticket Information
- Ticket ID: CVNP1606-W09-009
- Submitted by: Jordan Lee, Nexus Support Services Lead Technician
- Affected system: Multiple ACME endpoints
- Business impact: High, multiple employees unable to work or experiencing degraded performance

Scenario Summary

ACME had four tickets open at once on its busiest support day of the quarter, each touching a different skill area. The queue was read in full and prioritized by business impact before any tool was opened. Each ticket was then worked with the tool the ticket called for and closed or escalated with evidence. The prioritization paragraph and the per ticket notes are in ticket-pack.md.

## Ticket A - Account Lockout

Step: Unlock the cashier account acme-pos-cashier01 in Local Users and Groups, on the General tab of the account properties.
Expected output includes: the account is unlocked and enabled.
Status: Successful, screenshot a-01-unlock-action.png

Step: Open Event Viewer, Windows Logs, Security, and filter for the lockout and failed logon events.
Expected output includes: Event ID 4740 and Event ID 4625 for acme-pos-cashier01.
Status: Successful, screenshot a-02-security-log-4740-4625.png

## Ticket B - Slow Workstation

Step: Open Task Manager, Processes, sort by CPU.
Expected output includes: the top CPU consumer is identified.
Status: Successful, screenshot b-01-taskmgr-cpu.png

Step: In Task Manager, Processes, sort by Memory.
Expected output includes: the top memory consumer is identified.
Status: Successful, screenshot b-02-taskmgr-memory.png

Step: Check Task Manager Startup apps and Task Scheduler for the item launching the process.
Expected output includes: the scheduled task CVNP1606_CloudSyncAgent set to run at log on is identified as the cause.
Status: Successful

Step: End and disable the CVNP1606_CloudSyncAgent scheduled task and recheck the process list.
Expected output includes: the CPU and memory load drops and the workstation returns to normal.
Status: Successful

## Ticket C - Driver Failure

Step: Open Device Manager and find the audio device with the yellow warning icon under Other devices. On the General tab, read the error code.
Expected output includes: Error Code 28, the drivers for this device are not installed.
Status: Successful, screenshot c-01-code28-before.png

Step: On the Driver tab, Roll Back Driver was available but had no effect because no prior driver version was kept. The device was uninstalled, and Action, Scan for hardware changes was used. The device returned under Sound, video and game controllers after rescanning.
Expected output includes: the audio device is reinstalled and reports working.
Status: Successful, screenshot c-02-device-ok-after.png

## Ticket D - Network Connectivity

Step: Confirm IP assignment.

```
ipconfig /all
```

Expected output includes: an IP address and subnet mask, a non responding default gateway, and unreachable DNS servers.
Status: Successful, screenshot d-01-ipconfig-all.png

Step: Loopback test.

```
ping 127.0.0.1
```

Expected output includes: reply received, the TCP IP stack is working.
Status: Successful, screenshot d-02-ping-loopback.png

Step: Local IP test.

```
ping 10.10.50.102
```

Expected output includes: reply received, the adapter is bound and working.
Status: Successful, screenshot d-03-ping-localip.png

Step: Gateway test.

```
ping 10.10.50.253
```

Expected output includes: request timed out, the gateway is unreachable.
Status: Failed as expected, screenshot d-04-ping-gateway.png

Step: External test.

```
ping 8.8.8.8
```

Expected output includes: request timed out, no route to the internet.
Status: Failed as expected, screenshot d-05-ping-external.png

Step: Port test.

```
Test-NetConnection -ComputerName 10.10.50.253 -Port 445
```

Expected output includes: TcpTestSucceeded False.
Status: Failed as expected, screenshot d-06-testnetconnection-445.png

This ticket was escalated. The findings and the user instructions for Marcus are in ticket-pack.md.

## Troubleshooting Notes

Issue 1
- Incorrect command: Roll Back Driver on the audio device Driver tab
- Root Cause: the audio fault left no prior driver version in place, so Roll Back Driver had no effect when clicked
- Resolution: uninstalled the device and used Scan for hardware changes to reinstall the working driver from the local driver store
- Result: the audio device returned under Sound, video and game controllers with no error code

Issue 2
- Incorrect command: Scan for hardware changes did not re-detect the device on the first attempt
- Root Cause: the device was not immediately re-enumerated after the uninstall
- Resolution: repeated Scan for hardware changes until the device was re-detected
- Result: the audio device reinstalled from the local driver store and reported working

## Portfolio Card

### What I Can Do Now

I worked a four ticket mixed Windows support queue on an ACME endpoint, prioritized the tickets by business impact, and used Event Viewer, Task Manager, Resource Monitor, Device Manager, and the Windows networking commands to resolve or escalate an account lockout, a slow workstation, a failed audio driver, and a loss of network connectivity, each with documented evidence.

## AI Use Statement

AI assistance was used on this lab. The full disclosure is in ai-disclosure.md.

## Files In This Folder

- README.md, this file
- ticket-pack.md, the prioritization paragraph and the notes for all four tickets
- change-note.md, the change note for the Ticket C audio driver recovery
- ai-disclosure.md, the AI use disclosure
- collect-evidence.ps1, the evidence collection script
- evidence-report.txt, the generated evidence report
- screenshots, the labeled evidence screenshots for each ticket