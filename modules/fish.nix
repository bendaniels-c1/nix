{ pkgs, ... }:

let
  configDir = ../configs/fish;
in
{
  xdg.configFile = {
    "fish/config.fish".source = "${configDir}/config.fish";
    "fish/config.fish".force = true;
  };
}
