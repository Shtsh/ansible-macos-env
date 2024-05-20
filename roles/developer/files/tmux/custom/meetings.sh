show_meetings() {
  local index=$1
  local icon
  local color
  local result
  local text
  local module

  icon="$(get_tmux_option "@catppuccin_meetings_icon" "")"

  result=""

  color="$(get_tmux_option "@catppuccin_meetings_color" "$thm_blue")"

  text="$(get_tmux_option "@catppuccin_meetings_text" "$result")"
  module=$( build_status_module "$index" "$icon" "$color" "$text" )
  echo "$module"
}

