{ pkgs, ... }:

{
  xdg.configFile."revdiff/config".source = ../configs/revdiff/config;
}
