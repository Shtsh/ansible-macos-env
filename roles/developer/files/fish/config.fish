set -gx PATH "/usr/local/sbin:/usr/local/bin:/opt/homebrew/bin:/opt/homebrew/sbin:$HOME/.cargo/bin:$HOME/.rust-root/bin:$PATH"
set -U fish_greeting "🐟"

function ssh
  set ps_res (ps -p (ps -p %self -o ppid= | xargs) -o comm=)
  if [ "$ps_res" = "tmux" ]
    tmux rename-window " $(echo $argv | cut -d . -f 1)"
    command ssh $argv
    tmux set-window-option automatic-rename "on" 1>/dev/null
  else
    command ssh "$argv"
  end
end

function start_tmux
  if not set -q TMUX
      tmux attach-session || tmux new-session -t default
  end
end

alias vim=nvim

set -gx EDITOR nvim

if status is-interactive
  starship init fish | source
  fzf --fish | source
end
status --is-interactive; and source (rsvenv init |psub)
