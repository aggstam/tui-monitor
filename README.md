# tui-monitor
Simple Terminal UI to monitor processes like a custom stats curse script, htop and others.<br>
Two scripts are provided:
| Name           | Description                                                                        |
|----------------|------------------------------------------------------------------------------------|
| monitor.sh     | TUI tmux script to monitor multiple processes                                      |
| stats_curse.sh | Curse script to monitor system information and others, based on Bash Simple Curses |

# Dependencies
The following packages must be installed in your system:
1. tmux
2. htop
3. cava
4. curl
5. lm-sensors
6. nvidia-settings
7. smartctl
8. udisksctl

All package names provided are for Gentoo, so the naming in different distros may vary.<br>
Additionally, we need Bash Simple Curses[1] repo somewhere in the system:
```
$ git clone https://github.com/metal3d/bashsimplecurses.git
```

# Execution
Both scripts can be executed by using their name:
```
$ ./monitor.sh
# ./stats_curse.sh
```
We unfortunately need su priviledges to execute smartctl command, which is used to retrieve NVMe drives temperatures.<br>
Feel free to suggest a non su utility to replace smartctl, and/or remove it entirely if you don't use NVMe drives.

# Configuration
This section describes all the configuration needed to create your monitorring dashboard.

## monitor.sh
Script contains 3 processes to monitor:
1. stats_curse.sh script
2. htop
3. cava

Since this is a normal tmux script, you can add more processes to monitor.<br>
Don't forget to configure panes sizes for a nicer output.
Example dashboard:
![Screenshot](https://github.com/aggstam/tui-monitor/blob/main/screenshot.png)

## stats_curse.sh
First we need to define Bash Simple Curses path at line 28.
Example:
```
. `dirname $0`/../bashsimplecurses/simple_curses.sh
```

Script uses Open-Meteo API[2] to retrieve current weather information, so we must provide our latitude and longitude at lines 31 and 32.
Example:
```
lat=52.52
long=13.41
```

Now we can configure what we want to display in our window inside main function at line 217!<br>
Default configuration dispays basic system info like user, hostname, time, date and weather.<br>
Additionally we have system temperatures, like CPU, GPU and disks temperatures.<br>
A function to retrieve each component type temperature is provided, so you need to configure devices accordingly and append their records in main function.<br>

You can remove or add **anything** you want! 

# References
[1] Bash Simple Curses: https://github.com/metal3d/bashsimplecurses<br>
[2] Open-Meteo: https://open-meteo.com/
