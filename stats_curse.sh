#!/bin/bash
# --------------------------------------------------------------------------
#
# Curse script based on Bash Simple Curses lib, to monitor specific system information,
# like date, local weather using Open-Meteo API and temperature sensors.
# Usage: ./stats_curse.sh
#
# Bash Simple Curses: https://github.com/metal3d/bashsimplecurses
# Open-Meteo: https://open-meteo.com/
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

# Open-Meto weather api configuration
lat={YOUR_LATITUDE}
long={YOUR_LONGITUDE}
req="https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$long&current_weather=true"
rate=1800
count=0

# Auxilary function to retrieve weather information
weather() {
    # Execute request
    result="$(curl -s $req)"
    
    # Extract temperature
    prefix="\"temperature\"\:"
    pattern="$prefix[\-]?\d+\.\d+"
    string=$(echo "$result" | grep -oP "$pattern")
    temp="${string/#$prefix} °C"

    # Extract weather code
    prefix="\"weathercode\"\:"
    pattern="$prefix\d+"
    string=$(echo "$result" | grep -oP "$pattern")
    weather_code=${string/#$prefix}
    
    weather_description
}

# Auxilary function to map weather code to description
weather_description() {
    case $weather_code in
        0)
            desc="Clear sky"
            ;;

        1)
            desc="Mainly clear"
            ;;

        2)
            desc="Partly cloudy"
            ;;
        3)
            desc="Overcast"
            ;;
        45)
            desc="Fog"
            ;;
        48)
            desc="Depositing rime fog"
            ;;
        51)
            desc="Light drizzle"
            ;;
        53)
            desc="Moderate drizzle"
            ;;
        55)
            desc="Dense drizzle"
            ;;
        56)
            desc="Light freezing drizzle"
            ;;
        57)
            desc="Dense freezing drizzle"
            ;;
        61)
            desc="Slight rain"
            ;;
        63)
            desc="Moderate rain"
            ;;
        65)
            desc="Heavy rain"
            ;;
        66)
            desc="Light freezing rain"
            ;;
        67)
            desc="Heavy freezing rain"
            ;;

        71)
            desc="Slight snow fall"
            ;;
        73)
            desc="Moderate snow fall"
            ;;
        75)
            desc="Heavy snow fall"
            ;;
        77)
            desc="Snow grains"
            ;;
        80)
            desc="Slight rain showers"
            ;;
        81)
            desc="Moderate rain showers"
            ;;
        82)
            desc="Violent rain showers"
            ;;
        85)
            desc="Slight snow showers"
            ;;
        86)
            desc="Heavy snow showers"
            ;;
        95)
            desc="Thunderstorm"
            ;;
        96)
            desc="Thunderstorm with slight hail"
            ;;
        99)
            desc="Thunderstrom with heavy hail"
            ;;
        *)
            desc="Unknown weather code"
            ;;
    esac

    weather="$desc, $temp"
}

# Auxilary function to refresh weather information.
# Since main loop executes every 2 seconds,
# weather info is refreshed every hour(1800 = 0.5hr).
refresh_weather() {
    if [ $count -gt $rate ]; then
        weather
        count=0
    fi
    count=$(($count+1))
}

# Auxilary function to retrieve CPU temperatures
cpu_temps() {    
    cpu_temps="$(sensors)"

    # Extract Package temp
    pattern="Package id [0-9]:"
    package_temp=$(echo "$cpu_temps" | grep "$pattern" | grep -oP "\d+" | head -2 | tail -1)

    # Extract Cores temp.
    # Add one line for each core.
    pattern="Core 0:"
    cpu_temp0=$(echo "$cpu_temps" | grep "$pattern" | grep -oP "\d+" | head -2 | tail -1)

    pattern="Core 1:"
    cpu_temp1=$(echo "$cpu_temps" | grep "$pattern" | grep -oP "\d+" | head -2 | tail -1)

    pattern="Core 2:"
    cpu_temp2=$(echo "$cpu_temps" | grep "$pattern" | grep -oP "\d+" | head -2 | tail -1)

    pattern="Core 3:"
    cpu_temp3=$(echo "$cpu_temps" | grep "$pattern" | grep -oP "\d+" | head -2 | tail -1)
}

# Auxilary function to retrieve gpu temperatures
gpu_temps() {
    # Extract NVIDIA GPU core temp
    pattern="gpu:0"
    gpu_temp0=$(nvidia-settings -q gpucoretemp | grep "$pattern" | grep -oP "\d+" | tail -1)
}

# Auxilary function to retrieve disk temperatures
disks_temps() {
    # NVMe - We unfortunately need sudo priviledges to execute smartctl command
    pattern="Temperature"

    # NVMe
    nvme_temp=$(smartctl --all /dev/nvme0n1 | grep "$pattern" | grep -oP "\d+" | head -1)

    # SSDs and HDDs - udisksctl reports in Kelvin, so we convert to Celcius
    # We need to retrieve each disk info using their name and serial,
    # as reported by executing udisksctl status and replacing spaces and - with _.
    # Example: SSD_Name_Serial
    pattern="SmartTemperature: "

    # SSD
    raw_temp=$(udisksctl info -d SSD_Name_Serial | grep "$pattern" | grep -oP "\d+" | head -1)
    ssd_temp=$(($raw_temp-273))
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
    window "CPU temperatures" "red"
    cpu_temps
    append_tabbed "Package:$package_temp °C" 2
    # Add one line for each core.
    # Example: append_tabbed "Core N:$cpu_tempN °C" 2
    append_tabbed "Core 0:$cpu_temp0 °C" 2
    append_tabbed "Core 1:$cpu_temp1 °C" 2
    append_tabbed "Core 2:$cpu_temp2 °C" 2
    append_tabbed "Core 3:$cpu_temp3 °C" 2
    endwin
    
    # GPU temperatures
    window "GPU temperatures" "red"
    gpu_temps
    append_tabbed "NVIDIA GPU Model:$gpu_temp0 °C" 2
    endwin

    # Disks temperatures
    window "Disks temperatures" "red"
    disks_temps
    # Add one line for each disk.
    # Example: append_tabbed "Disk name:$sdd_tempN °C" 2
    append_tabbed "NVMe:$nvme_temp °C" 2
    append_tabbed "SSD:$hdd_temp1 °C" 2    
    endwin
}

# Initialize weather info
weather

# Start main loop
main_loop -t 2 "$@"
