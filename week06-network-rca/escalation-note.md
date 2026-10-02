# Escalation Note: Ticket CVNP1606-W06-006

## Ticket Summary

Emily Park, a remote ACME employee, could not reach the ACME intranet or shared drives from her laptop, ACME-EMILY-REMOTE. Diagnostics showed the fault was at the DNS layer. The DNS server on the network adapter was set to 1.2.3.4, which did not answer queries. The issue was resolved at tier 1 and no escalation was needed for this ticket.

## Actions Within Tier-1 Scope

These were completed by the helpdesk on this ticket:

1. Ran the diagnostic commands ipconfig /all, ping, nslookup, and Test-NetConnection, and saved the output to connectivity-evidence.txt.
2. Corrected the DNS server setting on the laptop from 1.2.3.4 back to 10.10.50.1.
3. Flushed the DNS cache with ipconfig /flushdns.
4. Verified the fix by running nslookup and Resolve-DnsName again and confirming the DNS server answered.
5. Wrote user-instructions.md so Emily can check the same setting herself if the problem returns.

These are tier 1 because they only change settings on the user's own laptop and can be undone in one step.

## Actions That Require Escalation

These were not needed on this ticket, but they are outside tier-1 scope and would be handed off:

### Escalation Item 1

The laptop's DNS is set up correctly, however, you cannot get ACME internal names to resolve; this would be an issue with either your ACME DNS server or VPN that carried the request. In other words, it has been narrowed down to a problem in infrastructure.

Contact information:
Kevin (ACME network administrator)

Handoff information:
Ticket #, hostname of laptop, IP address of laptop, gateway for laptop, DNS server from laptop as seen by ipconfig /all, name failed to resolve, full nslookup output, time of test.

### Escalation Item 2

You can ping, obtain an IP address, determine a gateway and have a valid DNS server, but when using Test-NetConnection against an ACME resource, it will fail to connect on the desired port. This suggests there is either a firewall rule blocking the connection or there is some misconfiguration in the VPN server.

Contact information:
Kevin (ACME network administrator)

Handoff information:
Ticket #, hostname of laptop, destination name/address being tested, port being tested against the destination, full Test-NetConnection output displaying TcpTestSucceeded False, confirmation that lower layers passed successfully, connectivity-evidence.txt

## Why the Boundary Is Here

Tier 1 fixes what is on the user's device. Any fix that means changing infrastructure, VPN server configuration, or firewall policy is handed off, because a mistake there affects every user and not only one laptop.