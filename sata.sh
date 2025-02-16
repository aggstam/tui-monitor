#!/bin/sh
# --------------------------------------------------------------------------
#
# Very simple script to grab SATA drive temperature, using `udisksctl`.
# Input is the disk combined name and serial, as reported by executing
# `udisksctl status` and replacing spaces and '-' with '_'.
# Output contains the drive smart temperature, in Celcius.
# Usage: ./sata.sh {Disk_Name_Serial}
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

# Extract SATA drive smart temperature
raw_temp=$(udisksctl info -d $1 | grep "SmartTemperature" | grep -oP "\d+" | head -1)

# udisksctl reports in Kelvin, so we convert to Celcius
temp=$(($raw_temp-273))

# Add positive sign
if [ $temp -ge 0 ]; then
    echo "+$temp°C"
else
    echo "$temp°C"
fi
