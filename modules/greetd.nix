{ config, lib, pkgs, ... }:
{
  imports = [
  ];

  environment.etc."greetd/environments".text = ''
    fish
    bash
  '';

  environment.systemPackages = with pkgs; [
    start-river
    start-sway
  ];

  services.greetd.enable = true;
  services.greetd.restart = true;
  services.greetd.vt = 7;
  services.greetd.settings = {
    #terminal.switch = false;

    default_session = {
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd start-river";
      #command = pkgs.greeter;
    };
  };
}
