{ pkgs, ... }:
{
  # Allow login as root or betawaffle by yubikey.
  security.pam.u2f.authFile = pkgs.writeText "u2f-mappings" ''
    root:HTUpPvR1N7mG24KegmPo70u86WxYwplIWIFRJ1j6Vf7xRaBW2g7L2MvPxh0LCcx310UDSwz7q9d78qY8osXqdg==,PyVXaMw7FXYCq2X1lYJ7n/2kUheZuPcj3vXE1HG/u6Bg07geej0uMPn6jJSdbRpwm1+Rt660CwZCxkb1Ol9xJA==,es256,+presence
    betawaffle:1K+OJPtSf92m2DeqR8CPcjdNhooh9lgO0Hmadxa3NJIR8mF3r6cvwhgeaikiDzaJKfnf8cCRugZBk/tj+vJASA==,nPwL8/pINMqJ83K5D1SanXCitk7Gh1803u2iwyzsi4D5KpCXmkyrUDXE1xguX7hFBJGdZhgSPfGIK42+gmUpaA==,es256,+presence
  '';

  # Show a message to remind me to touch the yubikey.
  security.pam.u2f.cue = true;

  # Enable pam-u2f module.
  security.pam.u2f.enable = true;
}
