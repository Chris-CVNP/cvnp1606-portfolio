Pilot group rollout plan
We will enroll all 50 ACME endpoints in four waves, one wave each week, and start with the low-risk users and end with the users ACME can least afford to lose.
Composition of waves:
Wave 1, week 1; five devices; IT staff at the Riverside branch. We will enroll these first as they have a high level of technical sophistication and would likely be able to identify any issues during the enrollment process. Their devices will be placed into a group called ACME-Pilot-Devices and this group will be configured to receive pilot policies, so only they will see the new policy changes made through the ACME-Pilot-Devices group.
Wave 2, week 2; ten devices; remaining staff at the Riverside branch. At this point we will test how well regular employees can successfully enroll. All of this testing will take place at a single location, the Riverside branch, which has an available IT staff person to provide support.
Wave 3, week 3; fifteen devices; general office users at other ACME locations. At this stage we will be testing employees using standard applications on non-business critical systems. Since these employees' devices are not business critical, we do not need to rush the deployment of these devices.
Wave 4, week 4; twenty devices; managers & business critical roles. We will roll out enrollment to the most senior role-based users in ACME last due to the fact that if their devices fail to operate properly it would create the greatest business disruption for ACME.
Criteria for advancing waves:
A wave may move forward when all of the following conditions are met:
Each device in the wave shows AzureAdJoined as YES in dsregcmd /status.
In addition to showing Managed by Intune, in the Intune admin center, each device's Last check-in date/time must show activity in the past 24 hours.
Each device must appear in the ACME-All-Devices group in Entra ID.
At least two full business days have passed since any enrollment tickets opened against devices in the wave were closed.
Stop or roll back criteria:
If any device in the current wave displays a blank MdmUrl, or is missing from Intune, or if any user reports loss of access to email, Teams, etc., then the entire rollout is paused until either the issue is resolved or until further evaluation determines whether a problem exists with the way that devices are configured/enrolled/managed.