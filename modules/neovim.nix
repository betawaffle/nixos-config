{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    neovim-unwrapped

    # Language Servers
    nodePackages.bash-language-server         # bashls
    ccls                                      # ccls
    clang-tools                               # clangd
    #cmake-language-server                    # cmake
    nodePackages.vscode-langservers-extracted # cssls
    gopls                                     # gopls
    nodePackages.vscode-langservers-extracted # jsonls
    #rust-analyzer                            # rust_analyzer
    sqls                                      # sqls
    nodePackages.typescript-language-server   # tsserver
    nodePackages.vim-language-server          # vimls
    nodePackages.yaml-language-server         # yamlls
    #zls                                      # zls

    # lua
    sumneko-lua-language-server # sumneko_lua
    stylua

    # nix
    alejandra
    deadnix
    statix

    # sh
    shellcheck
    shfmt
  ];

  environment.variables.EDITOR = "nvim";
}
