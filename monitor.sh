#!/bin/sh
# --------------------------------------------------------------------------
#
# Simple script to generate a new tmux session to monitor processes like
# stats curse script, htop and a cava audio visualizer.
# Usage: ./monitor.sh {optional session name}
#
# Author: Aggelos Stamatiou, July 2022
#
# This source code is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This software is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this source code. If not, see <http://www.gnu.org/licenses/>.
# --------------------------------------------------------------------------

# Initialize tmux session
session=$1
if [ -z $session ]; then
    session=tui-monitor
fi
tmux new-session -d -x "$(tput cols)" -y "$(tput lines)" -s $session

# Disabling status bar for cleaner look
tmux set status off

# Split window that will host htop
tmux split-window -v

# Split window that will host the cava session
tmux split-window -v -l 10

# Start cava
tmux send-keys "cava" Enter

# Start htop
tmux select-pane -t 1
tmux send-keys "htop" Enter

# Resize first pane
tmux select-pane -t 0
tmux resize-pane -U 8

# Start stats curse script
tmux send-keys "./stats_curse.sh" Enter

# Splitting complete, starting tmux session
tmux attach
