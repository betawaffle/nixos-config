{ ... }:
{
  # Don't leave any processes running from logged-out sessions.
  services.logind.killUserProcesses = true;

  # Completely declarative users.
  users.mutableUsers = false;

  # Define my user.
  users.users.betawaffle = {
    uid = 1000;
    isNormalUser = true;
    shell = "/run/current-system/sw/bin/fish";
    extraGroups = [
      "video"
      "wheel" # for sudo
    ];

    # Allow me to SSH into this machine, from my other machine(s).
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGOoS2y4QQVaShZF0l5WalSAJKLIQwcui71H7hzOL8Ad betawaffle+mac-pro@gmail.com"
    ];
  };

  # Allow the router to SSH in as root to run nix builds.
  #
  # FIXME: I should reverse the direction of this, and build/deploy from here
  # to the router.
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ56uFWU7PzIMhOO28uwVEQVtAF1rbQlU3QkFfB2mbkY root@router"
  ];
}
