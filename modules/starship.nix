{ pkgs, ... }:

{
  xdg.configFile."starship.toml".source = ../configs/starship/starship.toml;
}
