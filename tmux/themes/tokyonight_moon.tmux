# Global config
set -g mode-style "fg=#82aaff,bg=#3b4261"
set -g message-style "fg=#82aaff,bg=#3b4261"
set -g message-command-style "fg=#82aaff,bg=#3b4261"

set -g pane-border-style "fg=#3b4261"
set -g pane-active-border-style "fg=#82aaff"

set -g status "on"
set -g status-justify "left"
set -g status-style "fg=#82aaff,bg=#1e2030"

set -g status-left-length "100"
set -g status-right-length "100"

set -g status-left-style NONE
set -g status-right-style NONE

# Window status config
setw -g window-status-activity-style "underscore,fg=#828bb8,bg=#1e2030"
setw -g window-status-separator ""
setw -g window-status-style "NONE,fg=#828bb8,bg=#1e2030"
setw -g window-status-format "#[default] #I  #W #F"
setw -g window-status-current-format "#[default]#I  #W #F"

# Prefix config
set -g @prefix_highlight_empty_prompt " TMUX "
set -g @prefix_highlight_empty_attr "fg=#1e2131,bg=#82aaff"

set -g @prefix_highlight_prefix_prompt "PREFIX"
set -g @prefix_highlight_fg "#1e2131"
set -g @prefix_highlight_bg "#ffc777"

set -g @prefix_highlight_show_copy_mode 'on'
set -g @prefix_highlight_copy_prompt "COPY"
set -g @prefix_highlight_copy_mode_attr "fg=#1e2131,bg=#c099ff"

set -g @prefix_highlight_show_sync_mode 'on'
set -g @prefix_highlight_sync_prompt "SYNC"
set -g @prefix_highlight_sync_mode_attr "fg=#1e2131,bg=#c3e88d"

# CPU config
set -g @cpu_low_fg_color "#[fg=#82aaff]"
set -g @cpu_medium_fg_color "#[fg=#b8db87]"
set -g @cpu_high_fg_color "#[fg=#d86976]"
set -g @cpu_low_bg_color "#[bg=#575f7f]"
set -g @cpu_medium_bg_color "#[bg=#575f7f]"
set -g @cpu_high_bg_color "#[bg=#575f7f]"

set -g @ram_low_fg_color "#[fg=#82aaff]"
set -g @ram_medium_fg_color "#[fg=#b8db87]"
set -g @ram_high_fg_color "#[fg=#d86976]"
set -g @ram_low_bg_color "#[bg=#575f7f]"
set -g @ram_medium_bg_color "#[bg=#575f7f]"
set -g @ram_high_bg_color "#[bg=#575f7f]"

set -g @gpu_low_fg_color "#[fg=#82aaff]"
set -g @gpu_medium_fg_color "#[fg=#b8db87]"
set -g @gpu_high_fg_color "#[fg=#d86976]"
set -g @gpu_low_bg_color "#[bg=#575f7f]"
set -g @gpu_medium_bg_color "#[bg=#575f7f]"
set -g @gpu_high_bg_color "#[bg=#575f7f]"

# Left status bar
set -g status-left "\
#{prefix_highlight}\
#[fg=#82aaff,bg=#575f7f]\
#[fg=#82aaff,bg=#575f7f] #S \
#[fg=#575f7f,bg=#1e2030] "

# Right status bar
set -g status-right "#[fg=#575f7f,bg=#1e2030]\
#{gpu_fg_color}#{gpu_bg_color} 󰢮 #{gpu_percentage} \
#[fg=#82aaff,bg=#575f7f]\
#{cpu_fg_color}#{cpu_bg_color}  #{cpu_percentage} \
#[fg=#82aaff,bg=#575f7f]\
#{ram_fg_color}#{ram_bg_color}  #{ram_percentage} \
#[fg=#82aaff,bg=#575f7f]\
#[fg=#1e2131,bg=#82aaff]%d-%d-%Y %H:%M %Z"
