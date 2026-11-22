# Event Timeline

Ticket: CVNP1606-W08-008

| Timestamp | Event ID | Source | Level | Meaning |
|---|---|---|---|---|
| 2026-02-01 14:00:47 | 41 | Kernel-Power | Critical | The system rebooted without cleanly shutting down first. |
| 2026-02-01 14:02:26 | 6008 | EventLog | Error | Recorded at the next boot that the shutdown at 15:38:55 on 2026-01-31 was unexpected. |
| 2026-02-14 12:26:01 | 41 | Kernel-Power | Critical | The system rebooted without cleanly shutting down first. |
| 2026-02-14 12:26:04 | 6008 | EventLog | Error | Recorded at the next boot that the shutdown at 10:24:49 on 2026-02-14 was unexpected. |
| 2026-03-16 10:55:48 | 41 | Kernel-Power | Critical | The system rebooted without cleanly shutting down first. |
| 2026-03-16 10:55:52 | 6008 | EventLog | Error | Recorded at the next boot that the shutdown at 10:03:37 on 2026-03-06 was unexpected. |
| 2026-08-26 10:13:57 | 41 | Kernel-Power | Critical | The system rebooted without cleanly shutting down first. |
| 2026-08-26 10:13:59 | 6008 | EventLog | Error | Recorded at the next boot that the shutdown at 08:00:40 on 2026-08-26 was unexpected. |
| 2026-08-26 13:36:40 | 41 | Kernel-Power | Critical | The system rebooted without cleanly shutting down first. |
| 2026-08-26 13:37:05 | 6008 | EventLog | Error | Recorded at the next boot that the shutdown at 08:14:59 on 2026-08-26 was unexpected. |
| 2026-08-26 12:06:01 | 41 | Kernel-Power | Critical | The system rebooted without cleanly shutting down first. |
| 2026-08-26 12:06:25 | 6008 | EventLog | Error | Recorded at the next boot that the shutdown at 10:05:06 on 2026-08-26 was unexpected. |
| 2026-08-26 12:56:44 | 41 | Kernel-Power | Critical | The system rebooted without cleanly shutting down first. |
| 2026-08-26 12:57:10 | 6008 | EventLog | Error | Recorded at the next boot that the shutdown at 12:55:27 on 2026-08-26 was unexpected. |
| 2026-08-27 16:32:36 | 41 | Kernel-Power | Critical | The system rebooted without cleanly shutting down first. |
| 2026-08-27 16:41:54 | 6008 | EventLog | Error | Recorded at the next boot that the shutdown at 16:31:37 on 2026-08-27 was unexpected. |
| 2026-09-04 19:20:36 | 41 | Kernel-Power | Critical | The system rebooted without cleanly shutting down first. |
| 2026-09-04 19:21:20 | 6008 | EventLog | Error | Recorded at the next boot that the shutdown at 17:09:22 on 2026-08-27 was unexpected. |
| 2026-09-04 19:40:09 | 41 | Kernel-Power | Critical | The system rebooted without cleanly shutting down first. |
| 2026-09-04 19:41:05 | 6008 | EventLog | Error | Recorded at the next boot that the shutdown at 19:38:20 on 2026-09-04 was unexpected. |
| 2026-09-04 19:53:41 | 41 | Kernel-Power | Critical | The system rebooted without cleanly shutting down first. |
| 2026-09-04 19:54:14 | 6008 | EventLog | Error | Recorded at the next boot that the shutdown at 19:51:06 on 2026-09-04 was unexpected. |
| 2026-09-14 17:03:27 | 41 | Kernel-Power | Critical | The system rebooted without cleanly shutting down first. |
| 2026-09-14 17:04:35 | 6008 | EventLog | Error | Recorded at the next boot that the shutdown at 15:40:48 on 2026-09-14 was unexpected. |

## Timeline Summary

The evidence is based on a single failure pattern, and all twelve dirty shutdowns show the same behavior: a Kernel-Power 41 during boot-up, followed within seconds to minutes by an EventLog 6008 stating the time of the non-completing shutdown. There are no other Critical or Error events in this export that can indicate any other reason for any of the above. Since Events 41 & 6008 can't identify whether the system had a power outage/hard reset OR if it was hung, we need to look at the BugcheckCode value in each Kernel-Power 41 event. If the BugcheckCode = 0 then Windows didn't record a Stop Error, which will fit with either a power loss / forced power off / a hang. If there is a bug check code greater than 0 then you will know the system crashed.