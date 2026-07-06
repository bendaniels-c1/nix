{ pkgs, lib, ... }:

{
  home.activation.installGoTools = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    export PATH="${pkgs.go}/bin:$HOME/go/bin:$PATH"
    export GOPROXY=direct
    run ${pkgs.go}/bin/go install github.com/gerunddev/tcr@latest
    run ${pkgs.go}/bin/go install github.com/gerunddev/ralph@latest
    run ${pkgs.go}/bin/go install github.com/gerunddev/gsd@latest
  '';
}
