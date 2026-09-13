# CVNP1606 Week 3: Accounts, Identity, and Least Privilege

Ticket CVNP1606-W03-003 - Create seasonal staff account with appropriate privilege level, audit local group membership, and document the access rationale.

---

## Objectives

- Restore the virtual machine to a known good baseline
- Create a local user account named seasonal-staff
- Confirm the account is assigned the standard user account type
- Test User Account Control elevation behavior from the standard account
- Audit local user accounts with PowerShell
- Audit local Administrators group membership with PowerShell
- Export both audit results to local-users-export.txt
- Document the least-privilege reasoning behind each access decision

---

## Tools Used

- Windows Settings, Accounts, Other users
- Change account type dialog
- User Account Control
- Windows Security, Device security, Core isolation
- Windows PowerShell, run as Administrator
- Get-LocalUser
- Get-LocalGroupMember
- Out-File
- Get-Content
- dsregcmd
- Proxmox VE Snapshots
- Git and GitHub

---

## Configuration

### Ticket Information

- **Ticket ID:** CVNP1606-W03-003
- **Submitted By:** Jordan Lee, Nexus Support Services Lead Technician
- **Affected System:** ACME-W11-BASELINE
- **Business Impact:** High - seasonal staff cannot start work without accounts
- **Request:** Create seasonal staff account with appropriate privilege level, audit local group membership, and document the access rationale.

### Lab Environment

- **Guest:** CVNP1606-LAB-Win11
- **OS:** Windows 11 Enterprise Evaluation, build 26100.ge_release.240331-1435
- **Platform:** Dell PowerEdge R320 running Proxmox VE, VMID 101
- **Device state:** Microsoft Entra ID joined, not joined to an on-premises Active Directory domain

### Scenario Summary

ACME is onboarding seasonal staff who require Windows access to complete their work but must not hold administrator rights on their machines. The assigned work was to create the required account at the correct privilege level, confirm that privilege level rather than assume it, test what Windows actually does when that account attempts an action requiring elevation, and audit local Administrators group membership so that the privilege picture on the endpoint is documented rather than presumed. No seasonal account existed prior to this work and local Administrators group membership had not been audited. A written memo explaining the access decisions was also required so that the reasoning is available to a technician or manager who was not present for the work.

---

## Steps Taken

### Step 1: Restore the clean baseline

Rolled the virtual machine back to the W01_CleanBaseline snapshot in Proxmox VE, then powered the guest on and signed in with the administrator account.

**Expected output includes:** the Snapshots panel showing the baseline in the snapshot tree, and the Windows desktop reached after boot.

**Status:** Successful. See 01-snapshot-manager.png and 02-desktop-after-boot.png.

### Step 2: Create the seasonal-staff account

Created the account through Settings, Accounts, Other users, Add account, selecting the option to add a user without a Microsoft account.

**Expected output includes:** seasonal-staff listed under Other users.

**Status:** Successful.

### Step 3: Confirm the account type

Opened the account under Other users and selected Change account type.

**Expected output includes:** Account type reading Standard user.

**Status:** Successful. See 03-account-type-standard-user.png.

### Step 4: Test UAC elevation behavior

Signed out of the administrator account, signed in as seasonal-staff, and attempted to disable Local Security Authority protection under Windows Security, Device security, Core isolation.

**Expected output includes:** a User Account Control dialog blocking the action without administrator credentials.

**Status:** Successful. Windows presented a credential prompt requesting an administrator username and password rather than a simple consent prompt, which is the expected behavior for a standard user. No credentials were entered. See 04-uac-credential-prompt.png.

### Step 5: Audit local user accounts

```powershell
Get-LocalUser
```

**Expected output includes:** all local accounts with their enabled state, including seasonal-staff as enabled.

**Status:** Successful. See 05-local-group-audit.png.

### Step 6: Audit local Administrators group membership

```powershell
Get-LocalGroupMember -Group "Administrators"
```

**Expected output includes:** the members of the local Administrators group, with seasonal-staff absent.

**Status:** Successful. seasonal-staff does not appear in the Administrators group. Two members returned as unresolved security identifiers beginning S-1-12-1 with PrincipalSource listed as AzureAD. See 05-local-group-audit.png and Troubleshooting Notes below.

### Step 7: Export both audit results

```powershell
Get-LocalUser | Out-File -FilePath .\local-users-export.txt
```

```powershell
Get-LocalGroupMember -Group "Administrators" | Out-File -FilePath .\local-users-export.txt -Append
```

**Expected output includes:** no console output; local-users-export.txt written to the week folder containing both command results.

**Status:** Successful.

### Step 8: Verify the export

```powershell
Get-Content .\local-users-export.txt
```

**Expected output includes:** the Get-LocalUser table followed by the Administrators group membership table.

**Status:** Successful. Both results present in the file.

### Step 9: Confirm the device join state

```powershell
dsregcmd /status
```

**Expected output includes:** the Device State block reporting the directory join status of the machine.

**Status:** Successful. AzureAdJoined reported YES and DomainJoined reported NO. See 06-dsregcmd-status.png.

---

## Troubleshooting Notes

### Issue 1: Administrators group returned two members that did not resolve to names

**Observed output:** two entries beginning S-1-12-1 with PrincipalSource listed as AzureAD, alongside the built-in local Administrator account and one Entra user account.

**Root Cause:** the machine is Microsoft Entra ID joined. When a device is Entra joined, the security principals for the Global Administrator and Azure AD Joined Device Local Administrator directory roles are added to the local Administrators group at join time. These are cloud directory objects, so the local machine has no name to display for them and shows the raw security identifier instead. A security identifier beginning S-1-12-1 denotes an Entra directory object.

**Resolution:** confirmed the cause rather than treating the entries as a fault on the endpoint. Ran dsregcmd /status, which returned AzureAdJoined YES and DomainJoined NO, matching the presence of Entra principals in a local group and ruling out an on-premises domain as the source. No change was made to the endpoint, as the entries are expected behavior for an Entra joined device.

**Result:** the audit is accurate for the endpoint but incomplete as a privilege audit. Directory role holders are local administrators on every Entra joined device in the tenant without appearing by name in the local group, so local group membership alone cannot establish who holds administrator rights on this machine. Confirming who holds those roles requires tenant access and would be escalated to the tenant administrator before signing off on the privilege audit.

---

## Troubleshooting Narrative

**1. What went wrong, or what could realistically have gone wrong?**

While completing ticket cvnp1606-w03-003, I successfully created the seasonal-staff account as well as determined that the seasonal-staff account is a standard user with no local administrator privileges. When performing my local administrator audit, however, I found that there were two Azure Active Directory security identities within the Administrators group which did not resolve to any account or role names. Therefore, this presented a risk of false clean audit in that I would not be able to determine who actually had admin access based only on the output of the membership within a local group.

**2. What evidence did you check first?**

First I ran Get-LocalGroupMember -Group "Administrators" to verify the output. This resulted in a list of members which included the built-in Local Administrator Account, ****\****, and two additional entries starting with S-1-12-1 where their PrincipalSource was listed as AzureAD. As these two unknown SIDs were present it indicated that some cloud based Security Principals were assigned Local Administrator Rights; however they could not be identified using recognizable names.

**3. What did you try?**

I ran a "dsregcmd /status" command to see if my computer had joined a directory and to determine why principals from Azure AD appeared to be part of the local "Administrators" group. The output told me what the join state of this machine actually was. It said "AzureAdJoined : YES" which told me it was joined to Microsoft Entra ID; and it also said "DomainJoined : NO", which told me that the machine was not joined to an on-premises Active Directory domain.

**4. What fixed it, or what would you try next?**

There is no indication that the outstanding SIDs are a result of an error with the endpoint, therefore, nothing would need to be corrected at the endpoint. After verifying what Entra Directory Roles were represented by those SIDs, my next task would be to confirm who holds each role within the tenant. Should I not have permissions to verify this information, I would escalate the ticket to the appropriate administrator that administers the customer's Entra tenant versus approve the local administrator audit as complete.

**5. How did you verify the result?**

I was able to verify the source through a review of dsregcmd /status. It was indicated from the command output that AzureAdJoined was reporting "YES" while DomainJoined was showing "NO". Based on this information along with my verification of the Azure AD principals within the local Administrators Group, it has been determined that all of the unresolved entries are tied to the machine's membership in its cloud-based directory versus being members of an on-premises Active Directory domain.

**6. What was the support or security impact of the issue or fix?**

The security impact is that simply validating administrators for each endpoint will likely result in an incomplete representation of all those that have administrative privileges. Entra directory roles allow access to administrators to the joined device, yet they are represented by their role membership instead of their actual names within the local group. Therefore, if a technician utilized the local output as the complete audit, then the organization would be incorrect in its determination that least privilege had been verified. A proper support procedure is therefore to verify applicable cloud role membership or escalate it to the tenant administrator prior to signing off on the privilege audit.

---

## Portfolio Card

### What I Can Do Now

Used Windows Settings to create a user account, verified the account exists and is enabled with Get-LocalUser, and verified the user account did not have administrator privileges with Get-LocalGroupMember -Group "Administrators", helping ensure seasonal staff can do their jobs without having more access than their role requires.

---

## Files In This Folder

- README.md
- least-privilege-memo.md
- local-users-export.txt
- ai-disclosure.md
- ai-validation.md
- collect-evidence.ps1
- evidence-report.txt
- screenshots/01-snapshot-manager.png
- screenshots/02-desktop-after-boot.png
- screenshots/03-account-type-standard-user.png
- screenshots/04-uac-credential-prompt.png
- screenshots/05-local-group-audit.png
- screenshots/06-dsregcmd-status.png
