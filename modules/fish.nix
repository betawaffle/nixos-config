{ pkgs, ... }:
{
  # I use fish as my shell. This installs it and does some other stuff to make
  # it an allowed shell on NixOS.
  programs.fish.enable = true;

  # Use nix-index for command-not-found behavior, since we don't have a root
  # channel.
  programs.command-not-found.enable = false;
  programs.fish.shellInit = let
    wrapper = pkgs.writeScript "command-not-found" ''
      #!${pkgs.bash}/bin/bash
      source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
      command_not_found_handle "$@"
    '';
  in ''
    function __fish_command_not_found_handler --on-event fish_command_not_found
      ${wrapper} $argv
    end
  '';
}
