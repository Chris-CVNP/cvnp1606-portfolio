# Week 04: Storage, Sharing, and Permissions

Ticket CVNP1606-W04-004 | ACME-W11-BASELINE | Submitted by Jordan Lee, Nexus Support Services Lead Technician

---

## Objectives

- Create three local security groups to represent the HR access roles: HR-Managers, HR-Staff, and Audit-Readonly
- Create a standard local test account, hr-staff-test, belonging only to HR-Staff
- Build the HR payroll folder structure and share the Payroll folder over SMB
- Capture the NTFS ACL before and after the permission changes as an audit trail
- Remove the default Everyone entry from the share
- Apply group-based NTFS and share permissions matching each role
- Validate effective access from the hr-staff-test account context and document what is allowed and what is correctly blocked
- Produce a permissions matrix a peer or auditor could verify

---

## Tools Used

- New-LocalGroup
- Get-LocalGroup
- Read-Host
- New-LocalUser
- Add-LocalGroupMember
- Get-LocalGroupMember
- New-Item
- Get-Acl
- Out-File
- Get-Content
- New-SmbShare
- Revoke-SmbShareAccess
- Get-SmbShareAccess
- Grant-SmbShareAccess
- icacls
- File Explorer, Properties, Security tab
- collect-evidence.ps1

---

## Configuration

### Ticket Information

- Ticket ID: CVNP1606-W04-004
- Submitted by: Jordan Lee, Nexus Support Services Lead Technician
- Affected system: ACME-W11-BASELINE, acting as file server
- Request: Build the HR payroll share with group-based NTFS and share permissions, test effective access from multiple account contexts, and deliver a documented permissions matrix with ACL evidence.
- Business impact: High. Payroll data is sensitive. Incorrect permissions expose confidential records or lock out staff who need access to do their jobs.
- Initial evidence: No HR share exists. Default Everyone Full Control is present on the test share created during initial server setup.
- Required outcome: A secured HR share with group-based permissions, ACL evidence before and after, access test results from the HR-Staff account context, and a permissions matrix that could be handed to a peer or auditor.

### Scenario Summary

HR is moving payroll files to a dedicated shared folder on the ACME file server. Three groups need different levels of access: HR-Managers require Full Control so they can manage the folder and its contents, HR-Staff need Read and Write access to work with payroll files daily, and Audit-Readonly needs Read-only access for compliance review. No other users should be able to access the share. The current default Everyone permission on the parent share must be removed before the share goes live.

---

## Steps Taken

### Step 1: Create the HR-Managers group

```powershell
New-LocalGroup -Name "HR-Managers" -Description "Full control over HR Payroll share"
```

Expected output includes: the group name HR-Managers and its description returned in a table.

Status: Complete.

### Step 2: Create the HR-Staff group

```powershell
New-LocalGroup -Name "HR-Staff" -Description "Read/Write access to HR Payroll share"
```

Expected output includes: the group name HR-Staff and its description returned in a table.

Status: Complete.

### Step 3: Create the Audit-Readonly group

```powershell
New-LocalGroup -Name "Audit-Readonly" -Description "Read-only access for compliance review"
```

Expected output includes: the group name Audit-Readonly and its description returned in a table.

Status: Complete.

### Step 4: Verify all three groups exist

```powershell
Get-LocalGroup | Where-Object { $_.Name -like "HR*" -or $_.Name -like "Audit*" }
```

Expected output includes: all three groups, Audit-Readonly, HR-Managers, and HR-Staff, each with its description.

Status: Complete. See screenshots/01-local-groups-created.png.

### Step 5: Capture a password for the test account

```powershell
$pw = Read-Host -AsSecureString "Enter password for hr-staff-test"
```

Expected output includes: a masked prompt that stores the password as a secure string rather than plain text.

Status: Complete.

### Step 6: Create the hr-staff-test account

```powershell
New-LocalUser -Name "hr-staff-test" -Password $pw -FullName "HR Staff Test" -Description "Test account for HR-Staff access validation"
```

Expected output includes: hr-staff-test listed with Enabled showing True.

Status: Complete.

### Step 7: Add the test account to HR-Staff

```powershell
Add-LocalGroupMember -Group "HR-Staff" -Member "hr-staff-test"
```

Expected output includes: no output on success.

Status: Complete.

### Step 8: Confirm HR-Staff membership

```powershell
Get-LocalGroupMember -Group "HR-Staff"
```

Expected output includes: one member, hr-staff-test, with PrincipalSource Local.

Status: Complete. See screenshots/02-hr-staff-test-membership.png.

### Step 9: Confirm the test account is not an administrator

```powershell
Get-LocalGroupMember -Group "Administrators"
```

Expected output includes: the local Administrator account and the AzureAD entries, and no hr-staff-test.

Status: Complete. See screenshots/02-hr-staff-test-membership.png.

### Step 10: Create the CurrentYear folder

```powershell
New-Item -ItemType Directory -Path "C:\HR\Payroll\CurrentYear" -Force
```

Expected output includes: a directory entry for CurrentYear under C:\HR\Payroll.

Status: Complete.

### Step 11: Create the Archive folder

```powershell
New-Item -ItemType Directory -Path "C:\HR\Payroll\Archive" -Force
```

Expected output includes: a directory entry for Archive under C:\HR\Payroll.

Status: Complete.

### Step 12: Export the before-state ACL

```powershell
Get-Acl "C:\HR\Payroll" | Out-File "C:\HR\acl-before.txt"
```

Expected output includes: no console output. The file acl-before.txt is written to C:\HR.

Status: Complete, with a known limitation. See Troubleshooting Notes, Issue 1.

### Step 13: Read back the before-state ACL

```powershell
Get-Content "C:\HR\acl-before.txt"
```

Expected output includes: Path, Owner, and Access columns for C:\HR\Payroll.

Status: Complete.

### Step 14: Create the Payroll share

```powershell
New-SmbShare -Name "Payroll" -Path "C:\HR\Payroll" -FullAccess "Administrators"
```

Expected output includes: share name Payroll mapped to path C:\HR\Payroll.

Status: Complete.

### Step 15: Remove Everyone from the share permissions

```powershell
Revoke-SmbShareAccess -Name "Payroll" -AccountName "Everyone" -Force
```

Expected output includes: the resulting share ACL showing BUILTIN\Administrators only.

Status: Complete.

### Step 16: Verify Everyone is not present on the share

```powershell
Get-SmbShareAccess -Name "Payroll"
```

Expected output includes: BUILTIN\Administrators with Full, and no Everyone entry.

Status: Complete. See screenshots/03-payroll-share-everyone-removed.png.

### Step 17: Grant HR-Managers Full Control at the NTFS level

```powershell
icacls "C:\HR\Payroll" /grant "HR-Managers:(OI)(CI)F"
```

Expected output includes: processed file C:\HR\Payroll, 1 file processed, 0 failed.

Status: Complete.

### Step 18: Grant HR-Staff Modify at the NTFS level

```powershell
icacls "C:\HR\Payroll" /grant "HR-Staff:(OI)(CI)M"
```

Expected output includes: processed file C:\HR\Payroll, 1 file processed, 0 failed.

Status: Complete.

### Step 19: Grant Audit-Readonly Read and Execute at the NTFS level

```powershell
icacls "C:\HR\Payroll" /grant "Audit-Readonly:(OI)(CI)RX"
```

Expected output includes: processed file C:\HR\Payroll, 1 file processed, 0 failed.

Status: Complete.

### Step 20: Verify the NTFS entries

```powershell
icacls "C:\HR\Payroll"
```

Expected output includes: Audit-Readonly with (OI)(CI)(RX), HR-Staff with (OI)(CI)(M), and HR-Managers with (OI)(CI)(F), alongside the inherited entries for Administrators, SYSTEM, Users, and Authenticated Users.

Status: Complete. See screenshots/04-payroll-ntfs-permissions.png.

### Step 21: Grant HR-Managers Full at the share level

```powershell
Grant-SmbShareAccess -Name "Payroll" -AccountName "HR-Managers" -AccessRight Full -Force
```

Expected output includes: the updated share ACL with HR-Managers set to Full.

Status: Complete.

### Step 22: Grant HR-Staff Change at the share level

```powershell
Grant-SmbShareAccess -Name "Payroll" -AccountName "HR-Staff" -AccessRight Change -Force
```

Expected output includes: the updated share ACL with HR-Staff set to Change.

Status: Complete.

### Step 23: Grant Audit-Readonly Read at the share level

```powershell
Grant-SmbShareAccess -Name "Payroll" -AccountName "Audit-Readonly" -AccessRight Read -Force
```

Expected output includes: the updated share ACL with Audit-Readonly set to Read.

Status: Complete.

### Step 24: Verify the share permissions

```powershell
Get-SmbShareAccess -Name "Payroll"
```

Expected output includes: four entries, BUILTIN\Administrators Full, HR-Managers Full, HR-Staff Change, and Audit-Readonly Read.

Status: Complete. See screenshots/05-payroll-share-permissions.png.

### Step 25: Export the after-state ACL

```powershell
Get-Acl "C:\HR\Payroll" | Out-File "C:\HR\acl-after.txt"
```

Expected output includes: no console output. The file acl-after.txt is written to C:\HR.

Status: Complete, with a known limitation. See Troubleshooting Notes, Issue 1.

### Step 26: Create a file owned by the admin account for the deletion test

```powershell
New-Item -ItemType File -Path "C:\HR\Payroll\CurrentYear\admin-test-file.txt"
```

Expected output includes: a file entry for admin-test-file.txt under CurrentYear.

Status: Complete. Substituted step, see Troubleshooting Notes, Issue 2.

### Step 27: Test 1, create a file from the hr-staff-test context

Signed out of the admin account, signed in as hr-staff-test, opened File Explorer to \\localhost\Payroll\CurrentYear, and created a new text document.

Expected output includes: the file is created with no prompt or error.

Status: ALLOWED. See screenshots/06-hr-staff-create-file-allowed.png.

### Step 28: Test 2, edit and save the file

Opened the file created in Test 1, added a line of text, and saved.

Expected output includes: the save completes with no error and the file size updates in the folder listing.

Status: ALLOWED. See screenshots/07-hr-staff-edit-file-allowed.png.

### Step 29: Test 3, delete the admin-created file

Selected admin-test-file.txt and pressed Delete.

Expected output includes: the deletion result, allowed or blocked, as observed.

Status: ALLOWED. The file was removed with no access denied dialog. See screenshots/08-hr-staff-delete-admin-file-result.png.

### Step 30: Test 4, attempt to view or change permissions

Right-clicked the Payroll folder on the share, opened Properties, went to the Security tab, and attempted to apply a permission change.

Expected output includes: the attempt is blocked for a non-manager account.

Status: BLOCKED. Windows Security returned an error stating that it failed to enumerate objects in the container and access is denied. See screenshots/09-hr-staff-security-permissions-blocked.png.

### Step 31: Run the evidence collection script

```powershell
.\collect-evidence.ps1
```

Expected output includes: every required file reported as FOUND, and evidence-report.txt written to the week folder.

Status: Complete.

---

## Troubleshooting Notes

### Issue 1: ACL export files contained no access control entries

Incorrect command:

```powershell
Get-Acl "C:\HR\Payroll" | Out-File "C:\HR\acl-before.txt"
```

What went wrong

The ACL export from the lab guide did produce a file with the Folder Path and Owner, however it was very limited. It showed only one Access Entry, full control, then an ellipsis. All other entries were completely missing from the exported file. This resulted in the post state export being unable to show proof that the three HR Groups had been added to the folder.

What evidence I checked first

Instead of relying on whether or not the export succeeded, I read the contents of that file using Get-Content. Then I compared the information contained within that file to what is currently displayed as the active ACL for C:\HR\Payroll using icacls. The results were an eight-entry list for the folder, but a one-entry list in the file.

What I tried

The second attempt at exporting produced the same results, eliminating a onetime occurrence of this error. The exported file size was also small; less than would have been expected if all ACL information had been listed. So the file may contain only one or two lines of truncated ACL data.

What fixed it, or what I would try next

The truncation occurs due to formatting of output, rather than by Get-Acl. The out cmdlets don't format their output. They pass their object to a formatter in order to send the data to the appropriate destination; this includes the default length of the console which is 80 characters when sending data to the console. When piping Get-Acl directly into Out-File, the data will be sent to the console as a three-column table. So, if you pipe to Out-File after using Format-List, specifying the length of each item written to the file, the items will be listed one per line.

How I verified the result

I compared the entries in the corrected export against the live output of icacls on the same folder and confirmed every access control entry was present in the file.

Support or security impact

In addition to providing no data, an ACL export that is configured to drop all entries silently will actually look like a log or an audit trail of some sort but prove absolutely nothing. That means if you handed this over in the course of a compliance review, it could appear as though there was at least one entry made to the log for which the auditor may need further information. However, since the redirect only captured what fit inside the console width, it wouldn't be possible for anyone looking through the audit trail to find out that something was missing. So, it's always best practice to read back into the evidence file prior to turning it over to an auditor so that you can ensure that the evidence file has captured what was on the display.

### Issue 2: Test 3 had no admin-created file to delete

What went wrong

Task 3 of the assignment requires attempting to delete a file created by the admin account, but neither the assignment nor the lab guide includes a step that creates one. CurrentYear was empty at the point the test account signed in, so the test had nothing to act on.

What evidence I checked first

I listed the contents of \\localhost\Payroll\CurrentYear and confirmed the folder was empty before signing out of the admin account.

What I tried

I reviewed the assignment again and confirmed the deletion test is required as written, then signed back in to the admin account to stage a file for it.

What fixed it, or what I would try next

A substituted step was added to the build, New-Item creating C:\HR\Payroll\CurrentYear\admin-test-file.txt from the admin session before signing out. This is a deviation from the lab guide and is documented here rather than presented as part of the guide's procedure.

How I verified the result

I confirmed admin-test-file.txt was present in CurrentYear from the admin session, then confirmed from the hr-staff-test session that it was visible on the share before the deletion test was run.

Support or security impact

Test 3 ran as intended and returned ALLOWED, which is the correct outcome for a group holding Modify. The practical lesson is that an access test needs its preconditions staged from the right account context before the user session starts, because discovering the gap after signing out costs a full sign-in cycle.

---

## Portfolio Card

### What I Can Do Now

I used PowerShell and icacls to create a Group-Based Permission Model for the HR Payroll Share at ACME and removed the Everyone entry from the share so access is granted by group rather than to every user on the system. Effective access was then tested from the hr-staff-test account to confirm what was allowed versus what was not. This keeps payroll staff working while limiting every other role's permissions to only what the job requires.

---

## AI Use Statement

I used AI to assist in this assignment. I asked it to explain how deleting a file that was created by the administrator was successful when run under an account that had only Modify permissions. I also requested explanations of what would cause the ACL Export File to display only truncated entries. I executed each command myself and reviewed the result outputs prior to proceeding. I wrote the access test results, the permission matrix, the troubleshooting notes, and the written portions of this README in my own words based on what I actually saw during the build. I had the AI review my writing for accuracy and technical correctness.

---

## Files In This Folder

- README.md, this document
- access-test-results.md, the four effective access tests, the permissions matrix, and the least-privilege rationale
- acl-before.txt, the NTFS ACL captured before any permission changes
- acl-after.txt, the NTFS ACL captured after the group permissions were applied
- ai-validation.md, the AI use disclosure required by the assignment
- collect-evidence.ps1, the instructor-supplied evidence collection script
- evidence-report.txt, the output of the evidence collection script
- screenshots/01-local-groups-created.png
- screenshots/02-hr-staff-test-membership.png
- screenshots/03-payroll-share-everyone-removed.png
- screenshots/04-payroll-ntfs-permissions.png
- screenshots/05-payroll-share-permissions.png
- screenshots/06-hr-staff-create-file-allowed.png
- screenshots/07-hr-staff-edit-file-allowed.png
- screenshots/08-hr-staff-delete-admin-file-result.png
- screenshots/09-hr-staff-security-permissions-blocked.png
