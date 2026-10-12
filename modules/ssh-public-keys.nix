{ hosts, ... }:
{
  _module.args.sshPublicKeys = {
    # TODO: Generate these automatically?
    andy-mac-pro = "ssh-ed25519 ${hosts.andy-mac-pro.ssh-public-keys.user.betawaffle.ed25519} betawaffle@andy-mac-pro";
    andy-mac-pro-rsa = "ssh-rsa ${hosts.andy-mac-pro.ssh-public-keys.user.betawaffle.rsa} betawaffle@andy-mac-pro";
    andy-thelio = "ssh-ed25519 ${hosts.andy-thelio.ssh-public-keys.user.betawaffle.ed25519} betawaffle@andy-thelio";
    router = "ssh-ed25519 ${hosts.router.ssh-public-keys.user.root.ed25519} root@router";
  };
}
