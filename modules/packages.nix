{ pkgs, revdiff, ... }:

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

    # External flake packages
    pkgs.lumen
    revdiff.packages.${pkgs.stdenv.hostPlatform.system}.default

    # Fonts
    nerd-fonts.fira-code
    fira-code
    julia-mono
  ];

  fonts.fontconfig.enable = true;
}
