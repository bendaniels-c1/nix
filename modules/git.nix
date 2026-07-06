{ pkgs, ... }:

{
  xdg.configFile."git/config".source = ../configs/git/config;
}
