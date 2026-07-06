{ pkgs, ... }:

{
  xdg.configFile."tuicr/config.toml".source = ../configs/tuicr/config.toml;
}
