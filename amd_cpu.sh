#!/bin/sh
# --------------------------------------------------------------------------
#
# Very simple script to grab AMD CPU temperatures, using `lm-sensors`.
# Output is the processor temperature control value(Tctl), followed by each
# die temperature, in Celcius.
# Usage: ./amd_cpu.sh {dies count} {optional sensors chip id}
#
# Author: Aggelos Stamatiou, Mar 2025
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

# Grab sensors output
sensors=$(sensors $2)

# Parse Tctl temp
cpu_temps="$(parse_temp "$sensors" "Tctl")°C"

# Parse Dies temps
for ((i=1; i<=$1; i+=1))
do
    cpu_temps+=" $(parse_temp "$sensors" "Tccd$i")°C"
done

echo $cpu_temps
