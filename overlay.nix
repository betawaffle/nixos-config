final: prev:

{
  # Use the master version (from 2020-12-30), which added basic support for
  # the G-shift mode, meaning more buttons.
  #
  # It still doesn't support configuring the shifted color, and the piper UI
  # hasn't been updated yet.
  libratbag = prev.libratbag.overrideAttrs (old: rec {
    version = "b3275e1";

    src = final.fetchFromGitHub {
      owner  = "libratbag";
      repo   = "libratbag";
      rev    = "b3275e10d7eef0eeed2ede40fde6e5c727dce307";
      sha256 = "LXDoaQP2U8EimgP3XAzRG9oIxMo0wnKgQoDFU41QZsM=";
    };
  });
}
