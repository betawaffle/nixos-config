# Nag when the running configuration isn't on GitHub.
#
# moneta ran for four years on a commit that was never pushed. This checks,
# after every switch and once a day, that the commit the system was built
# from exists in github:betawaffle/nixos-config. If it doesn't (or the system
# was built from a dirty tree), the check unit fails and interactive shells
# print a warning until it's fixed.
{ config, lib, pkgs, ... }:

let
  rev = toString config.system.configurationRevision;
  repo = "betawaffle/nixos-config";
  flag = "/run/nixos-config-unpushed";
in

{
  systemd.services.config-pushed-check = {
    description = "Check that the running NixOS config is pushed to GitHub";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    # Changes with every build, so a switch re-runs the check.
    environment.CONFIG_REV = rev;

    path = [ pkgs.curl ];
    serviceConfig.Type = "oneshot";

    script = ''
      if [ -z "$CONFIG_REV" ]; then
        echo "This system was built from a dirty or non-git tree; commit and push it." | tee ${flag}
        exit 1
      fi

      code=$(curl -s -o /dev/null -w '%{http_code}' --max-time 20 \
        "https://api.github.com/repos/${repo}/commits/$CONFIG_REV" || true)

      case "$code" in
        200)
          rm -f ${flag}
          echo "Config $CONFIG_REV is on GitHub."
          ;;
        404|422)
          echo "Config $CONFIG_REV is not on GitHub (${repo}); push it." | tee ${flag}
          exit 1
          ;;
        *)
          echo "Couldn't reach GitHub (HTTP $code); will check again later."
          ;;
      esac
    '';
  };

  systemd.timers.config-pushed-check = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnUnitActiveSec = "1d";
      RandomizedDelaySec = "1h";
    };
  };

  environment.interactiveShellInit = ''
    if [ -e ${flag} ]; then
      printf '\033[1;33mwarning:\033[0m %s\n' "$(cat ${flag})" >&2
    fi
  '';
}
