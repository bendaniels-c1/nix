{ pkgs, ... }:

let
  configDir = ../configs/fish;
in
{
  programs.fish.enable = true;

  xdg.configFile = {
    "fish/config.fish".source = "${configDir}/config.fish";
    "fish/config.fish".force = true;
  };
}
