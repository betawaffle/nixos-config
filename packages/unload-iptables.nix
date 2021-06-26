{ iptables-nftables-compat
, kmod
, writeShellScriptBin
}:

writeShellScriptBin "unload-iptables" ''
  function flush {
    iptables=$1

    sudo $iptables -P INPUT ACCEPT
    sudo $iptables -P FORWARD ACCEPT
    sudo $iptables -P OUTPUT ACCEPT
    sudo $iptables -F
    sudo $iptables -X
    sudo $iptables -Z
    sudo $iptables -t nat -F
    sudo $iptables -t nat -X
    sudo $iptables -t mangle -F
    sudo $iptables -t mangle -X
    sudo $iptables -t raw -F
    sudo $iptables -t raw -X
  }

  function unload {
    sudo ${kmod}/bin/modprobe -rv "$@"
  }

  flush ${iptables-nftables-compat}/bin/iptables-legacy
  flush ${iptables-nftables-compat}/bin/ip6tables-legacy

  unload ip6table_filter ip6table_mangle ip6table_nat ip6table_raw
  unload ip6_tables

  unload iptable_filter iptable_mangle iptable_nat iptable_raw
  unload ip_tables

  unload ipt_REJECT

  unload xt_MASQUERADE
  unload xt_addrtype xt_comment xt_conntrack xt_mark xt_multiport xt_nat xt_statistic xt_tcpudp
  unload x_tables

  unload ip_set

  unload ip_vs_rr ip_vs_sh ip_vs_wrr
  unload ip_vs

  unload br_netfilter
''
