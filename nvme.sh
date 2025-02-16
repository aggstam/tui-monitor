#!/bin/sh
# --------------------------------------------------------------------------
#
# Very simple script to grab NVMe drive temperature, using `lm-sensors`.
# Output contains the drive composite temperature, in Celcius.
# Usage: ./nvme.sh {optional sensors chip id}
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

# Extract NVMe drive composite temperature
echo "$(sensors $1 | grep "Composite" | grep -oP "[+,-]\d+" | head -1)°C"
