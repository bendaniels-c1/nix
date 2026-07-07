{ pkgs, ... }:

{
  home.username = "squire";
  home.homeDirectory = "/home/squire";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
  home.shell.enableFishIntegration = true;

  imports = [
    ./modules/packages.nix
    ./modules/fish.nix
    ./modules/emacs.nix
    ./modules/git.nix
    ./modules/starship.nix
    ./modules/atuin.nix
  ];
}
