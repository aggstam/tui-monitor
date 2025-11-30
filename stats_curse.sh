#!/bin/sh
# --------------------------------------------------------------------------
#
# Curse script based on Bash Simple Curses lib, to monitor specific system information,
# like date, local weather and temperature sensors.
# Usage: ./stats_curse.sh
#
# Bash Simple Curses: https://github.com/metal3d/bashsimplecurses
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

# Bash Simple curses lib import
. `dirname $0`/bashsimplecurses/simple_curses.sh

# Weather script configuration
lat={YOUR_LATITUDE}
long={YOUR_LONGITUDE}

# Initialize weather info
weather=$(./weather.sh $lat $long)

# Auxilary function to refresh weather information.
# Since main loop executes every 2 seconds,
# weather info is refreshed every hour(1800 = 0.5hr).
count=0
refresh_weather() {
    if [ $count -gt 1800 ]; then
        weather=$(./weather.sh $lat $long)
        count=0
    fi
    count=$(($count+1))
}

# Monitors curse window
main() {
    # Basic information
    window "$USER@$HOSTNAME" "cyan"
    append "`date +"%H:%M"`"
    append "`date +"%A %d %B %Y"`"
    refresh_weather
    append "$weather"
    endwin

    # CPU temperatures
    window "CPU Temperatures" "red"
    # Use the corresponding script for the CPU manufacturer
    # AMD
    #cpu_dies=0
    #cpu_temps=($(./amd_cpu.sh $cpu_dies k10temp-pci-00c3))
    #append_tabbed "Temperature control:${cpu_temps[0]}" 2
    #for ((i=0; i<$cpu_dies; i+=1))
    #do
    #    append_tabbed "Die $i:${cpu_temps[$i+1]}" 2
    #done
    # Intel
    #cpu_cores=4
    #cpu_temps=($(./intel_cpu.sh $cpu_cores coretemp-isa-0000))
    #append_tabbed "Package:${cpu_temps[0]}" 2
    #for ((i=0; i<$cpu_cores; i+=1))
    #do
    #    append_tabbed "Core $i:${cpu_temps[$i+1]}" 2
    #done
    endwin

    # GPU information
    window "GPU Information" "red"
    # Use the corresponding script for the GPU manufacturer
    # AMD
    #gpu_info=($(./amd_gpu.sh {sensors chip id}))
    #append_tabbed "Edge Temperature:${gpu_info[0]}" 2
    #append_tabbed "Junction Temperature:${gpu_info[1]}" 2
    #append_tabbed "Memory Temperature:${gpu_info[2]}" 2
    #append_tabbed "Consuption (PPT):${gpu_info[3]}" 2
    # NVIDIA
    #gpu_info=($(./nvidia_gpu.sh {GPU index}))
    #append_tabbed "Core Temperature:${gpu_info[0]}" 2
    endwin

    # Disks temperatures
    window "Disks temperatures" "red"
    # Add one line for each disk, using the corresponding script for its type.
    # NVMe example: append_tabbed "Disk name:$(./nvme.sh {sensors chip id})" 2
    # SATA example: append_tabbed "Disk name:$(./sata.sh {sensors chip id})" 2
    #append_tabbed "NVMe:$(./nvme.sh {sensors chip id})" 2
    #append_tabbed "SSD:$(./sata.sh {sensors chip id})" 2
    #append_tabbed "HDD:$(./sata.sh {sensors chip id})" 2
    endwin
}

# Start main loop
main_loop -t 2 "$@"
