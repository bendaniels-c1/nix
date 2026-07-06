{ pkgs, ... }:

{
  xdg.configFile."atuin/config.toml".source = ../configs/atuin/config.toml;
}
