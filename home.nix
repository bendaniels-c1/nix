{ config, pkgs, lib, system, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
in
{
  home.username = "bendaniels";
  home.homeDirectory = if isDarwin then "/Users/bendaniels" else "/home/bendaniels";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  imports = [
    ./modules/packages.nix
    ./modules/fish.nix
    ./modules/emacs.nix
    ./modules/git.nix
    ./modules/starship.nix
    ./modules/ghostty.nix
    ./modules/atuin.nix
    ./modules/tuicr.nix
    ./modules/hunk.nix
  ];
}
