# Week 7: Devices, Drivers, and Peripherals

Ticket CVNP1606-W07-007 | CVNP 1606 Supporting Windows Operating Systems | C A | 10/08/2026

---

## Objectives

- Restore the VM to the W01_CleanBaseline snapshot and confirm a device fault in Device Manager
- Collect hardware evidence for the affected device and export it to hardware-inventory.txt
- Make and execute a rollback or reinstall decision and document it in a change note
- Write a rollback plan another technician can follow
- Generate evidence-report.txt with collect-evidence.ps1

---

## Tools Used

- Proxmox VE snapshot rollback
- Device Manager, opened with `devmgmt.msc`
- `Get-PnpDevice`
- `Where-Object`
- `Out-File`
- `New-Item`
- `Move-Item`
- `Set-Location`
- `collect-evidence.ps1`
- Git

---

## Configuration

### Ticket Information

- Ticket ID: CVNP1606-W07-007
- Submitted by: Alex Torres, ACME Office Manager
- Affected systems: HP LaserJet shared office printer and USB headset
- Request: Investigate driver state after Windows Update, restore device function, and document the change with a rollback plan
- Business impact: High
- Lab device with the fault: VMware Pointing Device

### Scenario Summary

I worked on this ticket as a Junior Technician at Nexus Support Services. Alex Torres, the ACME Office Manager, reported ticket number CVNP1606-W07-007 after Windows Update caused the shared HP LaserJet printer and an ACME USB headset to stop working. I was tasked with investigating why the devices were not functioning, restoring their functionality, and documenting the steps taken, along with a rollback plan so another technician could reverse the change if needed. In my lab VM, restored to the W01_CleanBaseline snapshot, the device with a fault was the VMware Pointing Device. It had a yellow warning triangle, and Device Manager listed it as Code 19. I collected all hardware evidence from that device and found that no roll back driver option was available; therefore, I uninstalled the pointing device and allowed Windows to reinstall the pointing device driver. The fault remained unresolved because the VM no longer runs on VMware, and the pointing device is no longer functional. Finally, I documented the change, the results, and the rollback procedure.

---

## Steps

### Step 1: Restore baseline and confirm a device fault

Reverted the VM to the W01_CleanBaseline snapshot, signed in, and opened Device Manager.

```
devmgmt.msc
```

This opens Device Manager, which shows the status of every hardware device Windows knows about.

Expected output includes: at least one device with a yellow warning triangle, red X, or unknown device indicator.

Status: Complete. VMware Pointing Device under Mice and other pointing devices showed a yellow warning triangle. The baseline already had a fault, so lab-fault.ps1 was not run. See screenshots/01-device-manager-fault.png.

### Step 2: List devices that are not in an OK state

```powershell
Get-PnpDevice | Where-Object {$_.Status -ne "OK"}
```

This lists every Plug and Play device Windows knows about and filters the list to devices whose status is not OK.

Expected output includes: the affected device with a status other than OK.

Status: Complete. VMware Pointing Device was listed with a status of Error in the Mouse class. See screenshots/02-get-pnpdevice-output.png.

### Step 3: Export the output to hardware-inventory.txt

```powershell
Get-PnpDevice | Where-Object {$_.Status -ne "OK"} | Out-File hardware-inventory.txt
```

This writes the filtered device list to hardware-inventory.txt.

Expected output includes: no output on screen and a new hardware-inventory.txt file.

Status: Complete. The file was created in the repo root instead of the week folder. See Issue 2 under Troubleshooting Notes.

### Step 4: Append the full device list

```powershell
Get-PnpDevice | Out-File hardware-inventory.txt -Append
```

This adds the full device list to the end of the file without overwriting the first export.

Expected output includes: no output on screen and a larger hardware-inventory.txt file.

Status: Complete.

### Step 5: Record the device properties in Device Manager

Selected VMware Pointing Device in Device Manager, opened its Properties, and recorded the values from three tabs in hardware-inventory.txt.

Expected output includes: an error code and status message on the General tab, a Hardware ID on the Details tab, and the driver provider, date, and version on the Driver tab.

Status: Complete.

- Device selected with the warning visible: screenshots/03-device-selected.png
- General tab: Code 19, Windows cannot start this hardware device because its configuration information in the registry is incomplete or damaged. See screenshots/04-general-tab.png.
- Details tab, Hardware Ids: `ACPI\VEN_PNP&DEV_0F13`, `ACPI\PNP0F13`, `*PNP0F13`. See screenshots/05-details-tab.png.
- Driver tab: provider Broadcom Inc., date 10/22/2024, version 12.5.15.0. Roll Back Driver was greyed out. See screenshots/06-driver-tab-before.png.

### Step 6: Move hardware-inventory.txt into the week folder

```powershell
New-Item -ItemType Directory -Force week07-driver-change-note
```

This creates the week folder and returns no error if the folder already exists.

```powershell
Move-Item hardware-inventory.txt week07-driver-change-note\
```

This moves the inventory file from the repo root into the week folder.

```powershell
Set-Location week07-driver-change-note
```

This changes the working folder to the week folder so later files are created there.

Expected output includes: the folder listing from New-Item, no output from Move-Item, and a prompt that ends in week07-driver-change-note.

Status: Complete. See Issue 2 under Troubleshooting Notes.

### Step 7: Make and execute the rollback or reinstall decision

Roll Back Driver was greyed out, so I right-clicked VMware Pointing Device, chose Uninstall device, left the box to delete the driver package unchecked, and let Windows reinstall the driver on the next hardware scan.

Expected output includes: the device returns in Device Manager with no warning icon.

Status: Complete, fault not cleared. The device returned with the same yellow warning triangle. See Issue 1 under Troubleshooting Notes, change-note.md, and screenshots/07-device-manager-after.png.

### Step 8: Write the rollback plan

Wrote rollback-plan.md with the restore target, the steps to restore the prior state, the responsible party, the verification check, and the escalation path.

Status: Complete. See rollback-plan.md.

### Step 9: Run the evidence collection script

```powershell
.\collect-evidence.ps1
```

This checks the week folder for the required files and writes the result to evidence-report.txt.

Expected output includes: every required file showing FOUND.

Status: Complete. evidence-report.txt was generated and every required file shows FOUND.

---

## Evidence List

- hardware-inventory.txt
- change-note.md
- rollback-plan.md
- evidence-report.txt
- screenshots/01-device-manager-fault.png
- screenshots/02-get-pnpdevice-output.png
- screenshots/03-device-selected.png
- screenshots/04-general-tab.png
- screenshots/05-details-tab.png
- screenshots/06-driver-tab-before.png
- screenshots/07-device-manager-after.png

---

## Troubleshooting Narrative

**What went wrong, or what could realistically have gone wrong?**

The VMware Pointing Device had a yellow warning triangle in Device Manager with Code 19. Code 19 indicates to me that Windows can't start this device due to missing or corrupted configuration in the registry. When I attempted to reinstall the VMware pointing driver, it didn't correct the error. It appears that since this VM is no longer running on VMware and therefore all of the VMware software has been uninstalled, this is a left over device from a prior installation and Windows will not be able to successfully run this legacy device.

**What evidence did you check first?**

I looked in the Device Manager to see if there was an issue at all; after finding the warning icon next to VMware Pointing Device, I then ran Get-PnpDevice to get a list of devices that were not okay and filtered it so that only those devices would be returned. That is when I saw the status of Error. Once I had seen that status, I documented the error code off of the General tab, the Hardware ID off of the Details tab, and the driver provider, date, and version off of the Driver tab.

**What did you try?**

I checked the Roll Back Driver button on the Driver tab and found it greyed out, so a rollback was not possible. I uninstalled the device in Device Manager, left the box to delete the driver package unchecked, and let Windows reinstall the driver on the next hardware scan.

**What fixed it, or what would you try next?**

The reinstall did not work. Windows brought back the same driver after installing again. A yellow triangle still was displayed on the device. The next action under the lab guide would be either a manual installation of the driver for the device or escalate this issue to my lead. I will escalate because the previous steps were attempted; I have evidence of that and I know that this is a known leftover from VMware so there is no reason to do another reinstallation of the same driver.

**How did you verify the result?**

I reviewed Device Manager after the change to check on device status. The same warning was displayed as before for VMware Pointing Device; no warnings were displayed for HID-compliant mouse or Remote Desktop Mouse Device. I captured an image of what the Device Manager looked like at that point to include in the change note.

**What was the support or security impact of the issue or fix?**

The support impact is low. The other two pointing devices have no faults. However, an unexplained warning icon may cause the next tech to look for a fault that is already understood. The change note and rollback plan document the cause so the next technician does not repeat the work. On the security side, I used the same signed driver package as before; therefore, I was able to avoid downloading a driver from an outside location which would be an unverified driver.

---

## Troubleshooting Notes

### Issue 1: Reinstall did not clear the fault on VMware Pointing Device

I uninstalled VMware Pointing Device in Device Manager without checking the box to remove the driver package; afterward, Windows reinstalled the driver when it ran another hardware scan. It showed up again with its yellow warning triangle.

I removed the VM from VMware, and I removed all VMware software from it. So, VMware Pointing Device remains a trace of the VMware install. After Windows reinstalled the same Broadcom Inc. driver, version 12.5.15.0 dated 10/22/2024, the device could not be brought into operation. In addition to being unable to bring the device online, the Roll Back Driver button was greyed out, so there were no previous driver versions to roll back to.

A second install of the device or a manual install was not attempted. The failure was documented as a known leftover device in the change note, and I wrote a rollback plan with an escalation path to my lead.

VMware Pointing Device continues to display a yellow warning triangle, while neither the HID-compliant mouse nor the Remote Desktop Mouse Device shows a warning symbol. The ticket outcome of one device restored to working condition was not met for this device, and the reasons are documented.

### Issue 2: hardware-inventory.txt was exported to the wrong folder

I ran the export commands in Steps 3 and 4 from the root of the cvnp1606-portfolio repo instead of the week07-driver-change-note folder. The file was created in the repo root, and the prompt in screenshots/02-get-pnpdevice-output.png shows that location.

Out-File writes to the current folder when no path is given, and I had not changed into the week folder before I ran the commands.

I created the week folder, moved the file into it, and changed into that folder with the three commands in Step 6. I did not rerun the export because the contents of the file were correct.

hardware-inventory.txt is now in week07-driver-change-note with the other deliverables, and every later file was created in that folder.

---

## What I Can Do Now

I diagnosed a device fault from a help desk ticket using Device Manager and Get-PnpDevice, attempted a driver reinstall when rollback was not available, and wrote a change note and rollback plan so the next technician knows the cause of the fault and how to reverse the change.

---

## AI Use Statement

Tool: Claude by Anthropic.

What it helped with: It helped verify the accuracy of each piece of evidence that I used for the assignment. It also drafted the change note and the README pieces that I rewrote, and it wrote the rollback plan from my results.

How I verified its output against real evidence: For all device names, Error codes, Hardware IDs & driver details listed in the documentation files, I confirmed every item against my own screenshots from Device Manager, as well as the output of Get-PnpDevice in hardware-inventory.txt.

See ai-validation.md and ai-disclosure.md in this folder.

---

## Files In This Folder

- README.md
- hardware-inventory.txt
- change-note.md
- rollback-plan.md
- ai-validation.md
- ai-disclosure.md
- collect-evidence.ps1
- evidence-report.txt
- screenshots/01-device-manager-fault.png
- screenshots/02-get-pnpdevice-output.png
- screenshots/03-device-selected.png
- screenshots/04-general-tab.png
- screenshots/05-details-tab.png
- screenshots/06-driver-tab-before.png
- screenshots/07-device-manager-after.png