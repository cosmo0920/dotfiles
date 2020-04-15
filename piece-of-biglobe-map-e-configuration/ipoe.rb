# ref: http://ipv4.web.fc2.com/map-e.html
# v6plus ref: https://api.enabler.ne.jp/6a4a89a8639b7546793041643f5da608/get_rules?callback=v6plus

ceipv6addr = "<CE IPv6 Address>"
eastbraddr = "2001:260:700:1::1:275" # for east-flets
outeripv4 = "<Outer IPv4 address>"
portranges = "<IPv4 port range>"
ports = portranges.split(' ')
config = <<-EOC
# ---- IPv6 configuration ----
ipv6 routing on
ipv6 prefix 1 ra-prefix@lan2::/64

description lan1 LAN
ipv6 lan1 address ra-prefix@lan2::1/64
ipv6 lan1 rtadv send 1 o_flag=on
ipv6 lan1 dhcp service server

description lan2 "Biglobe FTTH IPoE"
# CE IPv6 address #{ceipv6addr}
ipv6 lan2 address #{ceipv6addr}/64
ipv6 lan2 mtu 1500
# ipv6 lan secure filter in part
# ipv6 lan secure filter out part
ipv6 lan2 dhcp service client ir=on

# IPv4 related
ip route default gateway tunnel 1
  description tunnel MAP-E
  tunnel select 1
  tunnel encapsulation ipip
  tunnel endpoint address #{ceipv6addr} #{eastbraddr}
  ip tunnel mtu 1460
  ip tunnel nat descriptor 1010 1011 1012 1013
  tunnel enable 1

# NAT table for IPv6 tunnel - 1
nat descriptor type 1010 masquerade
nat descriptor address outer 1010 #{outeripv4}
nat descriptor address inner 1010 auto

# NAT table for IPv6 tunnel - 2
nat descriptor type 1011 masquerade
nat descriptor address outer 1011 #{outeripv4}
nat descriptor address inner 1011 auto

# NAT table for IPv6 tunnel - 3
nat descriptor type 1012 masquerade
nat descriptor address outer 1012 #{outeripv4}
nat descriptor address inner 1012 auto

# NAT table for IPv6 tunnel - 4
nat descriptor type 1013 masquerade
nat descriptor address outer 1013 #{outeripv4}
nat descriptor address inner 1013 auto

nat descriptor masquerade port range 1010 #{ports[0..3].join(' ')}
nat descriptor masquerade port range 1011 #{ports[4..7].join(' ')}
nat descriptor masquerade port range 1012 #{ports[8..11].join(' ')}
nat descriptor masquerade port range 1013 #{ports[12..15].join(' ')}

# Some filtering configurations...
EOC

print config
