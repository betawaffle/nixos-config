{ lib, ... }:

let
  # TODO: Figure out how much of this I can give back to the standard NixOS
  # options for networking. Doing this all myself feels janky, and it's not
  # portable if I decide to stop using networkd.

  # Prefix to use for network unit files.
  #
  # FIXME: Switch this to 40 to match what nixos uses?
  prio = "10";

  # Helper to DRY-out link configuration.
  mkLink = { name, path, vlanOnly ? false }: {
    # Define a link unit to avoid 99-default.link.
    systemd.network.links."${prio}-${name}" = {
      # Match the link by its udev ID_PATH.
      matchConfig.Path = path;

      # Rename the link, rather than using the kernel-generated default.
      #
      # One caveat to this is it will only be renamed once (during boot), but
      # other units that match on the name will only match the new name. Thus,
      # if you're trying to rename this, you should use nixos-rebuild boot,
      # and then reboot to activate it.
      linkConfig.Name = name;
    };

    # Configure the link's network.
    systemd.network.networks."${prio}-${name}" = {
      # Match the link by its name.
      #
      # FIXME: Perhaps we should match this by ID_PATH too, so it's not
      # dependent on the name?
      matchConfig.Name = name;

      linkConfig = lib.mkIf vlanOnly {
        # Disable ARP, since ARP packets would be untagged.
        ARP = false;

        # Tell networkd to stop complaining about the operational state, since
        # carrier is all we're gonna get with ARP disabled.
        RequiredForOnline = "carrier";
      };

      networkConfig = lib.mkIf vlanOnly {
        # Disable all link-local addressing, which eliminates another source of
        # untagged traffic.
        LinkLocalAddressing = "no";
      };
    };
  };

  # Helper to DRY-out VLAN configuration.
  mkVLAN = { id, link, name, desc, addr ? null }: {
    # Create the VLAN netdev unit.
    systemd.network.netdevs."${prio}-${name}" = {
      # We want a VLAN.
      netdevConfig.Kind = "vlan";

      # Set the desired name for the VLAN.
      #
      # One caveat to this is it will only be named once, but other units that
      # match on the name will only match the new name. Thus, if you're trying
      # to rename this, you should use nixos-rebuild boot, and then reboot to
      # activate it.
      netdevConfig.Name = name;

      # Set the description.
      netdevConfig.Description = desc;

      # Set the VLAN number.
      vlanConfig.Id = id;
    };

    # Add it as a subordinate of the desired link.
    systemd.network.networks."${prio}-${link}".vlan = [ name ];

    # Configure the VLAN's network.
    systemd.network.networks."${prio}-${link}-${toString id}" = {
      # Match the netdev by its name.
      matchConfig.Name = name;

      # FIXME: Does this need to be explicitly enabled?
      linkConfig.ARP = true;

      # Use DHCP if no address is configured.
      networkConfig = lib.mkIf (addr == null) { DHCP = "yes"; };

      # Configure the specified address otherwise.
      address = lib.mkIf (addr != null) [ addr ];
    };
  };
in

{
  config = lib.mkMerge [
    # enp68s0
    (mkLink {
      name = "eth";
      path = "pci-0000:44:00.0";
      vlanOnly = true;
    })

    # VLANs
    (mkVLAN {
      id = 1;
      link = "eth";
      name = "lan";
      desc = "Default VLAN";
    })
    (mkVLAN {
      id = 2;
      link = "eth";
      name = "management"; # FIXME: Rename to mgt.
      desc = "Management VLAN";
      addr = "192.168.2.10/24";
    })
    (mkVLAN {
      id = 4;
      link = "eth";
      name = "dmz";
      desc = "DMZ VLAN";
      addr = "192.168.4.10/24";
    })
    (mkVLAN {
      id = 5;
      link = "eth";
      name = "lab";
      desc = "Lab VLAN";
      addr = "192.168.5.10/24";
    })
  ];
}
