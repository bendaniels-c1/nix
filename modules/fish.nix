{ pkgs, ... }:

let
  configDir = ../configs/fish;
in
{
  xdg.configFile = {
    "fish/config.fish".source = "${configDir}/config.fish";
    "fish/functions/gwt.fish".source = "${configDir}/functions/gwt.fish";
    "fish/functions/office.fish".source = "${configDir}/functions/office.fish";
  };
}
