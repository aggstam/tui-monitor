# tui-monitor

Simple Terminal UI to monitor processes like a custom stats curse script, htop and others.<br>
The monitor is based on a collection of basic scripts that are combined to build a highly customizable dashboard.<br>
Each script can be individually executed and/or used as the building block for creating your own custom monitor/dashbord.<br>
Go through the whole document to learn more about each script and how to properly configure and customize your monitor.<br>
Each script will be described in its own section, containing its required configuration and dependencies.<br>
All package names provided are for Gentoo, so the naming in different distros may vary.<br>

## Information retrieval scripts

This section describes all the auxilliary scripts used to retrieve system information.<br>
For the scripts that use `lm-sensors`, it is highly recomended to first detect sensors
and then grab each chip id to use in the scripts, by running:

```
# sensors-detect
% sensors
```

### amd_cpu.sh

Retrieves AMD CPU processor temperature control value(Tctl), followed by each die temperature, in Celcius.

#### Dependencies

* `lm-sensors`

#### Usage

```
% ./amd_cpu.sh {dies count} {optional sensors chip id}
```

### intel_cpu.sh

Retrieves Intel CPU package temperature, followed by each core temperature, in Celcius.

#### Dependencies

* `lm-sensors`

#### Usage

```
% ./intel_cpu.sh {cores count} {optional sensors chip id}
```

### amd_gpu.sh

Retrieves AMD GPU edge, junction and memory temperatures, in Celcius,
along with the current PPT watts value.

#### Dependencies

* `lm-sensors`

#### Usage

```
% ./amd_gpu.sh {optional sensors chip id}
```

### nvidia_gpu.sh

Retrieves NVIDIA GPU current core temperature, in Celcius.

#### Dependencies

* `nvidia-settings`

#### Usage

```
% ./nvidia_gpu.sh {GPU index}
```

### nvme.sh

Retrieves NVMe drive composite temperature, in Celcius.

#### Dependencies

* `lm-sensors`

#### Usage

```
% ./nvme.sh {optional sensors chip id}
```

### sata.sh

Retrieves SATA drive temperature, in Celcius.

#### Dependencies

* `lm-sensors`

#### Usage

```
% ./sata.sh {optional sensors chip id}
```

### weather.sh

Retrieves local weather from Open-Meteo API[1], for provided latitude and longitute.

#### Dependencies

* `curl`

#### Usage

```
% ./weather.sh {latitude} {longitute}
```

## stats_curse.sh

Curse script to monitor system information and others, based on Bash Simple Curses[2].<br>
We are using Bash Simple Curses repo as a `git` submodule, so on initial pull:

```
% git submodule update --init
```

To pull updates:

```
% git pull --recurse-submodules
```

### Configuration

Script uses the weather script to retrieve current local weather information, so we must provide our latitude and longitude at lines 30 and 31.
Example:
```
lat=52.52
long=13.41
```

Now we can configure what we want to display in our window inside main function at line 49!<br>
Default configuration displays basic system info like user, hostname, time, date and weather.<br>
Additionally we can configure system devices information retrieval, like CPU, GPU and disks temperatures.<br>
Examples on how to retrieve each component type information is provided, so you need to configure devices accordingly and append their records in main function.<br>

You can remove or add **anything** you want!

### Usage

```
% ./stats_curse.sh
```

## monitor.sh

Tha main TUI tmux script to monitor multiple processes.

#### Dependencies

* `tmux`
* `htop`
* `cava`

### Configuration

Since this is a normal `tmux` script, you can add more processes to monitor.<br>
Don't forget to configure panes sizes for a nicer output.<br>
Example dashboard:

![Screenshot](https://github.com/aggstam/tui-monitor/blob/main/screenshot.png)

### Usage

```
% ./monitor.sh
```

## References

[1] Open-Meteo: https://open-meteo.com/<br>
[2] Bash Simple Curses: https://github.com/metal3d/bashsimplecurses
