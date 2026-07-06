{ pkgs, lib, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
in
{
  home.packages = with pkgs; [
    # Core CLI tools
    bat
    direnv
    eza
    fd
    fzf
    glow
    gum
    jq
    ripgrep
    wget

    # Shells and shell tools
    fish
    atuin
    starship
    zoxide

    # Version control
    git
    lazygit

    # Editors
    emacs

    # Languages and toolchains
    go
    gopls
    golangci-lint

    # Fonts
    nerd-fonts.fira-code
    fira-code
    julia-mono
  ];

  fonts.fontconfig.enable = true;
}
