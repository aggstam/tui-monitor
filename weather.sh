#!/bin/sh
# --------------------------------------------------------------------------
#
# Very simple script to grab local weather from Open-Meteo API, for provided
# latitude and longitute.
# Usage: ./weather.sh {latitude} {longitute}
#
# Open-Meteo: https://open-meteo.com/
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

# Auxilary function to map provided weather code to description.
weather_description() {
    case $1 in
        0)
            echo "Clear sky"
            ;;

        1)
            echo "Mainly clear"
            ;;

        2)
            echo "Partly cloudy"
            ;;
        3)
            echo "Overcast"
            ;;
        45)
            echo "Fog"
            ;;
        48)
            echo "Depositing rime fog"
            ;;
        51)
            echo "Light drizzle"
            ;;
        53)
            echo "Moderate drizzle"
            ;;
        55)
            echo "Dense drizzle"
            ;;
        56)
            echo "Light freezing drizzle"
            ;;
        57)
            echo "Dense freezing drizzle"
            ;;
        61)
            echo "Slight rain"
            ;;
        63)
            echo "Moderate rain"
            ;;
        65)
            echo "Heavy rain"
            ;;
        66)
            echo "Light freezing rain"
            ;;
        67)
            echo "Heavy freezing rain"
            ;;

        71)
            echo "Slight snow fall"
            ;;
        73)
            echo "Moderate snow fall"
            ;;
        75)
            echo "Heavy snow fall"
            ;;
        77)
            echo "Snow grains"
            ;;
        80)
            echo "Slight rain showers"
            ;;
        81)
            echo "Moderate rain showers"
            ;;
        82)
            echo "Violent rain showers"
            ;;
        85)
            echo "Slight snow showers"
            ;;
        86)
            echo "Heavy snow showers"
            ;;
        95)
            echo "Thunderstorm"
            ;;
        96)
            echo "Thunderstorm with slight hail"
            ;;
        99)
            echo "Thunderstrom with heavy hail"
            ;;
        *)
            echo "Unknown weather code"
            ;;
    esac
}

# Execute request
req="https://api.open-meteo.com/v1/forecast?latitude=$1&longitude=$2&current_weather=true"
result="$(curl -s $req)"

# Extract weather code description
prefix="\"weathercode\"\:"
pattern="$prefix\d+"
string=$(echo "$result" | grep -oP "$pattern")
desc=$(weather_description ${string/#$prefix})

# Extract temperature
prefix="\"temperature\"\:"
pattern="$prefix[\-]?\d+\.\d+"
string=$(echo "$result" | grep -oP "$pattern")
temp="${string/#$prefix}°C"

echo "$desc, $temp"
