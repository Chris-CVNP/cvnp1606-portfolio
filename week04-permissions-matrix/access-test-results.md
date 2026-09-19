Test Environment

Tests were conducted using the hr-staff-test user account, which has no membership in any groups other than HR-Staff. In addition, tests were performed on the network path \\localhost\Payroll rather than the local path C:\HR\Payroll; therefore, each test applied all share permissions and all NTFS permissions.

Test 1: Create a new file in CurrentYear

Result: ALLOWED

I went to \\localhost\Payroll\CurrentYear and made a new document using Notepad. No prompts or errors appeared during creation, and it showed up in the current year listing immediately. This behavior is correct because the user HR-Staff has the right to modify the directory at the NTFS level, as well as change it at the Share Level, and therefore has permission to create documents.

Test 2: Open the file, edit it, and save

Result: ALLOWED

I opened the file created in Test 1, typed a single line of text into it, and then saved it. When I saved it, I did not get an error message, and the file's new size appeared in the folder listing, which confirmed my write went to the shared resource instead of being cached somewhere. To have write access across your network, you need to have share permissions and NTFS permissions for the directory, allowing it; both are present here.

Test 3: Delete a file created by the admin account

Result: ALLOWED

The file admin-test-file.txt had been created in the CurrentYear folder by the administrator account before this test. Selecting it and clicking Delete deleted the file without displaying an access denied dialog box. The remaining item in the folder was then the hr-staff-test file. This is the proper behavior for this configuration. Since Modify allows deleting of both files and folders, all members of a group that have been granted Modify permissions can delete any file in the folder whether they are the owner or another user created the file.

Test 4: View or change permissions on the Payroll folder

Result: BLOCKED

Right clicked on Payroll folder from share and selected Properties then security tab. I attempted to apply a permission change but was presented with an error message that reads as follows: Windows Security, an error occurred while applying security information to \\localhost\Payroll. Failed to enumerate objects in the container. Access is denied. The change was not applied. This is expected behavior for a non-manager account. Changing permissions or taking ownership of an item is reserved for full control which hr-staff does not have. So an account holding only Modify will allow you to work with the items inside the folder but will not allow you to alter who has access to the folder.

Permissions Matrix

Group Name | NTFS Permission | Share Permission | Effective Network Access | Test Result
HR-Managers | Full Control | Full Control | Full Control | Not tested in this exercise
HR-Staff | Modify | Change | Modify | Tests 1, 2, and 3 ALLOWED, Test 4 BLOCKED
Audit-Readonly | Read and Execute | Read | Read and Execute | Not tested in this exercise

Effective Network Access is a more restricted version of the two permission sets. The NTFS permissions are applied whether you have access via local access or remote access. Share permissions are only applicable for access through the network. When both exist on an item, the restriction will be the most severe. As a result of having HR-Staff with NTFS Modify, and share Change, they would allow the user to work at the same level. As a result of this, HR-Staff will be able to use NTFS Modify. Both share Read, and NTFS Read & Execute both stop short of any write, so the effective result is read-only.

Rationale

Audit-ReadOnly is set as Read and Execute instead of Modify. The purpose of an audit is to review information. Auditors need to access employee payroll files and confirm their content. Nothing about this role involves creating, editing, or deleting anything within the files. Giving modify capabilities to this group will provide them with the capability to alter the exact same documents being audited. This creates a serious risk if the account was to be compromised.

Everyone was removed from the shared folder. The share currently allows all users who are logged into the system to have full rights as opposed to only allowing those that belong to one of the three specific HR job functions. This greatly reduces the number of people that have access to the share. Using actual groups for each job function also makes it easier to track changes. When a new employee is added to a group or a current employee's group is changed, this is easily traceable via Computer Management.

The two decisions both apply to the least privilege principle; Each of the groups gets the minimum amount of access needed for their jobs as well as nothing else and they remove access that a given role doesn't need instead of keeping it in there by default.
