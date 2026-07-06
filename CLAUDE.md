# CLAUDE.md

## Repository Purpose

Declarative system configuration using Nix Home Manager with flakes. Manages dotfiles and packages for macOS and Linux.

## Project Structure

- `flake.nix` — Flake entry point with nixpkgs and home-manager inputs
- `home.nix` — Main config that imports all modules and sets user identity
- `modules/` — One Nix module per tool:
  - `packages.nix` — All Nix packages (replaces Brewfile)
  - `fish.nix`, `emacs.nix`, `git.nix`, etc. — Config file placement
  - `go-tools.nix` — Activation script for personal Go tools
  - `shell-extras.nix` — Activation script for gh-dash extension
- `configs/` — Raw config files placed by Home Manager via `xdg.configFile`/`home.file`

## Key Commands

```bash
# Apply configuration (macOS)
home-manager switch --flake .#"bendaniels@darwin"

# Apply configuration (Linux)
home-manager switch --flake .#"bendaniels@linux"

# Preview changes
home-manager build --flake .#"bendaniels@darwin"

# Check flake validity
nix flake check
```

## Version Control Preference

**Always prefer Jujutsu (jj) over Git.** See the rig repo CLAUDE.md for full jj workflow details.

## Configuration Conventions

### Adding a New Tool

1. Place config file(s) in `configs/<tool>/`
2. Create `modules/<tool>.nix` that uses `xdg.configFile` to place the config
3. Add the package to `modules/packages.nix`
4. Import the new module in `home.nix`

### Adding a New Package

Add it to the `home.packages` list in `modules/packages.nix`.

### Design Principles

- **Raw config files** — Configs live in `configs/` as normal files, not Nix DSL. This keeps them editable without Nix knowledge.
- **One module per tool** — Clean separation, easy to add/remove.
- **Activation scripts** — For tools that can't be built in Nix's sandbox (private Go repos, gh extensions).
