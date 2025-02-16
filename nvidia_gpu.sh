#!/bin/sh
# --------------------------------------------------------------------------
#
# Very simple script to grab NVIDIA GPU temperature, using `nvidia-settings`.
# Output contains the GPU current core temperature, in Celcius.
# Usage: ./nvidia_gpu.sh {GPU index}
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

# Extract NVIDIA GPU core temperature
temp=$(nvidia-settings -q gpucoretemp | grep "gpu:$1" | grep -oP "[-]?\d+" | tail -1)

# Add positive sign
if [ $temp -ge 0 ]; then
    echo "+$temp°C"
else
    echo "$temp°C"
fi
