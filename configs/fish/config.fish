atuin init fish --disable-up-arrow | source
starship init fish | source
zoxide init fish --cmd=cd | source
fzf --fish | source

fish_add_path ~/.nix-profile/bin
fish_add_path ~/.local/bin
fish_add_path (go env GOPATH)/bin
fish_add_path /home/linuxbrew/.linuxbrew/bin
fish_add_path ~/.local/bin/claude
fish_add_path ~/.cargo/bin
fish_add_path /Applications/Obsidian.app/Contents/MacOS/

set fish_greeting
set -gx EDITOR emacs

# Check if we're in an interactive shell
if status is-interactive

    # At this point, specify the Zellij config dir, so we can launch it manually if we want to
    export ZELLIJ_CONFIG_DIR=$HOME/.config/zellij

    # Check if our Terminal emulator is Ghostty
    # if [ "$TERM" = "xterm-ghostty" ]
    # end

    # Remote session setup (SSH/mosh)
    if set -q SSH_CONNECTION; or set -q SSH_TTY
        # Fix true color support - mosh supports 24-bit color but only advertises 256
        # Setting COLORTERM=truecolor enables true color in starship and other apps
        # This is safe since modern terminals (Ghostty, iTerm2, etc.) all support it
        if not set -q COLORTERM
            set -gx COLORTERM truecolor
        end
        # Ensure TERM is at least 256color capable
        if test "$TERM" = "xterm"
            set -gx TERM xterm-256color
        end

        # Auto-attach to zellij session
        if not set -q ZELLIJ
            zellij attach -c dev
        end
    end
end

# Fish color scheme - Catppuccin Mocha
set -g fish_color_autosuggestion 6c7086
set -g fish_color_cancel f38ba8
set -g fish_color_command 89b4fa
set -g fish_color_comment 6c7086
set -g fish_color_cwd f9e2af
set -g fish_color_cwd_root f38ba8
set -g fish_color_end fab387
set -g fish_color_error f38ba8
set -g fish_color_escape f2cdcd
set -g fish_color_history_current --bold
set -g fish_color_host a6e3a1
set -g fish_color_host_remote a6e3a1
set -g fish_color_normal cdd6f4
set -g fish_color_operator 94e2d5
set -g fish_color_param f5c2e7
set -g fish_color_quote a6e3a1
set -g fish_color_redirection fab387
set -g fish_color_search_match --background=313244
set -g fish_color_selection --background=313244
set -g fish_color_status f38ba8
set -g fish_color_user 94e2d5
set -g fish_color_valid_path --underline

# Fish pager colors - Catppuccin Mocha
set -g fish_pager_color_background
set -g fish_pager_color_completion cdd6f4
set -g fish_pager_color_description f9e2af -i
set -g fish_pager_color_prefix 89b4fa --bold --underline
set -g fish_pager_color_progress cdd6f4 --background=313244
set -g fish_pager_color_secondary_background
set -g fish_pager_color_secondary_completion
set -g fish_pager_color_secondary_description
set -g fish_pager_color_secondary_prefix
set -g fish_pager_color_selected_background --background=45475a
set -g fish_pager_color_selected_completion cdd6f4
set -g fish_pager_color_selected_description f9e2af
set -g fish_pager_color_selected_prefix 89b4fa

# Modern CLI tool aliases
alias cat="bat"
alias rat="bat --paging=always"
alias ls="eza"
alias ll="eza -la --git"
alias tree="eza --tree"
alias find="fd"
alias grep="fzg"
alias glow="glow -p"
alias em="fzf --bind 'enter:become(emacs {})'"

set -U EDITOR "emacs"
set -U VISUAL "emacs"

# fzf configuration with preview and Catppuccin Mocha theme
set -x FZF_DEFAULT_OPTS "\
--bind 'ctrl-e:become(emacs {})' \
--color=bg+:#313244,spinner:#f5e0dc,hl:#f38ba8 \
--color=header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--color=border:#585b70,label:#cdd6f4,query:#cdd6f4"
set -x FZF_DEFAULT_COMMAND "fd --type f --hidden --follow --exclude .git --exclude .jj"
set -x FZF_CTRL_T_OPTS "--preview 'bat -n --color=always {}'"
set -x FZF_ALT_C_OPTS "--preview 'eza --tree --color=always {}'"

set -g fish_key_bindings fish_default_key_bindings

function fzp
    fzf $argv --style full --preview 'fzf-preview.sh {}' --bind 'focus:transform-header:file --brief {}'
end

function fzg -d "Find using ripgrep, then view with fzf preview"
    if [ -z "$argv" ]
        echo "Usage: fzg <search-string>"
        return 1
    end

    set query "$argv"

    rg --color=always --line-number --no-heading --smart-case $query | \
        fzf --ansi \
            --color "hl+:yellow" \
            --delimiter ":" \
            --with-nth "1,3" \
            --preview "bat --color=always --highlight-line {2} --line-range {2}: {1}" \
	    --style full \
	    --bind "enter:become(emacs +{2} {1})"
end
