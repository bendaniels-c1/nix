{ pkgs, ... }:

let
  configDir = ../configs/emacs;
in
{
  home.file.".emacs.d/init.el".source = "${configDir}/init.el";
  home.file.".emacs.d/.gitignore".source = "${configDir}/.gitignore";
}
