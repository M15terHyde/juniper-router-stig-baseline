control 'SV-233299' do
  title 'The Juniper perimeter router must be configured to drop IPv6 packets containing a Hop-by-Hop or Destination Option extension header with an undefined option type.'
  desc 'The optional and extensible natures of the IPv6 extension headers require higher scrutiny since many implementations do not always drop packets with headers that it cannot recognize, and hence could cause a Denial-of-Service on the target device. In addition, the type, length, value (TLV) formatting provides the ability for headers to be very large.'
  desc 'check', 'This requirement is not applicable for the DODIN Backbone. 

Review the router configuration and determine if filters are bound to the applicable interfaces to drop all inbound IPv6 packets containing an undefined option type value regardless of whether they appear in a Hop-by-Hop or Destination Option header. Undefined values are 0x02, 0x03, 0x06, 0x9 – 0xE, 0x10 – 0x22, 0x24, 0x25, 0x27 – 0x2F, and 0x31 – 0xFF.

The following example will block any inbound IPv6 packet containing either a Hop-by-Hop or Destination Option header: 

    family inet6 {
        filter IPV6-INGRESS-FILTER {
            term HOP_BY_HOP_HEADER {
                from {
                    next-header hop-by-hop;
                }
                then {
                    syslog;
                    discard;
                }
            }
            term DEST_ OPT_HEADER {
                from {
                    next-header dstops;
                }
                then {
                    syslog;
                    discard;
                }
            }
            term ALLOW_TCP_ESTABLISHED {
                from {
                    next-header tcp;
                    tcp-established;
                }
                then accept;
            }
            term DENY_BY_DEFAULT {
                then {
                    syslog;
                    discard;
                }
            }
        }
    }
}



Note: Currently JUNOS has no method to filter option type within either Hop-by-Hop or Destination Option header. Hence, all packets with a Hop-by-Hop or Destination Option headers must be dropped.

If the router is not configured to drop IPv6 packets containing a Hop-by-Hop or Destination Option extension header with an undefined option type, this is a finding.'
  desc 'fix', 'Step 1: Configure a filter to block packets with either a Hop-by-Hop or Destination Option header as shown in the example.

user@R1# edit firewall family inet6
user@R1# edit filter IPV6-INGRESS-FILTER
user@R1# set term HOP_BY_HOP_HEADER from next-header hop-by-hop
user@R1# set term HOP_BY_HOP_HEADER then discard syslog
user@R1# set term DEST_ OPT_HEADER from next-header dstops
user@R1# set term DEST_ OPT_HEADER then discard syslog
user@R1# top

Step 2: Apply the filter inbound on all external IPv6-enabled interfaces.

user@R1# edit interfaces ge-0/0/0 unit 0 family inet6
user@R1# set filter input IPV6-INGRESS-FILTER
user@R1# commit'
  impact 0.5
  tag check_id: 'C-36234r639660_chk'
  tag severity: 'medium'
  tag gid: 'V-233299'
  tag rid: 'SV-233299r604135_rule'
  tag stig_id: 'JUNI-RT-000387'
  tag gtitle: 'SRG-NET-000364-RTR-000206'
  tag fix_id: 'F-36203r639661_fix'
  tag 'documentable'
  tag cci: ['CCI-002403']
  tag nist: ['SC-7 (11)']
end
