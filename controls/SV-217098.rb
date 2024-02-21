control 'SV-217098' do
  title 'The Juniper Multicast Source Discovery Protocol (MSDP) router must be configured to use its loopback address as the source address when originating MSDP traffic.'
  desc 'Using a loopback address as the source address offers a multitude of uses for security, access, management, and scalability of MSDP routers. It is easier to construct appropriate ingress filters for router management plane traffic destined to the network management subnet since the source addresses will be from the range used for loopback interfaces instead of a larger range of addresses used for physical interfaces. Log information recorded by authentication and syslog servers will record the router’s loopback address instead of the numerous physical interface addresses.'
  desc 'check', 'Review the router configuration to verify that a loopback address has been configured.

interfaces {
    …
    …
    …
    lo0 {
        unit 0 {
            family inet {
                address 2.2.2.2/32;
            }
        }
    }
}

Verify that the loopback interface is used as the source address for all MSDP packets generated by the router.

protocols {
    msdp {
        group AS25 {
            peer 5.5.5.5 {
                local-address 2.2.2.2;
            }
        }
    }

If the router does not use its loopback address as the source address when originating MSDP traffic, this is a finding.'
  desc 'fix', 'Configure the router to use its loopback address is used as the source address when sending MSDP packets.

[edit protocols msdp]
set group AS_5 peer 5.5.5.5 local-address 2.2.2.2'
  impact 0.3
  tag check_id: 'C-18327r297162_chk'
  tag severity: 'low'
  tag gid: 'V-217098'
  tag rid: 'SV-217098r604135_rule'
  tag stig_id: 'JUNI-RT-000940'
  tag gtitle: 'SRG-NET-000512-RTR-000011'
  tag fix_id: 'F-18325r297163_fix'
  tag 'documentable'
  tag legacy: ['SV-101189', 'V-90979']
  tag cci: ['CCI-000366']
  tag nist: ['CM-6 b']
end