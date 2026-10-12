let
  hosts = import ../hosts/meta.nix;

  mkUserKey = kind: host: user: "ssh-${kind} ${hosts.${host}.ssh-public-keys.user.${user}.${kind}} ${user}@${host}";
  mkHostKey = kind: host: "ssh-${kind} ${hosts.${host}.ssh-public-keys.host.${kind}} root@${host}";
in

{
  "netbox-secret-key.age".publicKeys = [
    (mkUserKey "ed25519" "andy-thelio" "betawaffle")
    (mkHostKey "ed25519" "andy-thelio")
  ];
}
