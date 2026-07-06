# Nix Home Manager Configuration

Declarative system configuration using Nix Home Manager with flakes. Manages dotfiles and packages for macOS and Linux.

## Prerequisites

Install Nix via the [Determinate Systems installer](https://determinate.systems/nix-installer/):

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

## Usage

### macOS (Apple Silicon)

```bash
home-manager switch --flake .#"bendaniels@darwin"
```

### Linux (x86_64)

```bash
home-manager switch --flake .#"bendaniels@linux"
```

### Preview changes without applying

```bash
home-manager build --flake .#"bendaniels@darwin"
```

### Remove all managed files

```bash
home-manager uninstall
```

## Structure

- `flake.nix` — Flake entry point (inputs: nixpkgs, home-manager)
- `home.nix` — Main Home Manager configuration, imports all modules
- `modules/` — One Nix module per tool (packages, fish, emacs, git, etc.)
- `configs/` — Raw config files placed by Home Manager via `xdg.configFile`

## macOS GUI Apps (Manual Install)

These require manual download — not managed by Nix:

- [Claude](https://claude.ai/download)
- [Ghostty](https://ghostty.org)
- [Mouseless](https://mouseless.app)
- [OrbStack](https://orbstack.dev)
- Magnet, Theine, Hidden Bar (Mac App Store)

## Not in nixpkgs (installed via activation scripts or manually)

- `jj-starship` — `go install github.com/dmmulroy/jj-starship@latest`
- `jjazy` — install from gerunddev/tap or `go install`
- `tuicr` — install from agavra/tap
- Personal Go tools (tcr, ralph, gsd) — installed automatically via activation script
- `gh-dash` — installed automatically via activation script
