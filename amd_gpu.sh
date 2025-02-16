#!/bin/sh
# --------------------------------------------------------------------------
#
# Very simple script to grab AMD GPU information, using `lm-sensors`.
# Output contains the GPU edge, junction and memory temperatures, in Celcius,
# along with the current PPT watts value.
# Usage: ./amd_gpu.sh {optional sensors chip id}
#
# Author: Aggelos Stamatiou, Feb 2025
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

# Auxilary function to parse sensors output temperature for provided pattern.
parse_temp() {
    echo "$1" | grep "$2" | grep -oP "[+,-]\d+" | head -1
}

# Auxilary function to parse sensors output watt for provided pattern.
parse_watt() {
    echo "$1" | grep "PPT" | grep -oP "\d+" | head -1
}

# Grab sensors output
sensors=$(sensors $1)

# Parse edge temp
gpu_temps="$(parse_temp "$sensors" "edge")°C"

# Parse junction temp
gpu_temps+=" $(parse_temp "$sensors" "junction")°C"

# Parse memory temp
gpu_temps+=" $(parse_temp "$sensors" "mem")°C"

# Parse PPT
gpu_temps+=" $(parse_watt "$sensors")W"

echo $gpu_temps
