# Raspberry Pi 3 Some Tools

I mistook a adjust because vcgencmd gets values slow. So I remake all.

BTW you set to force_turbo=1 in /boot/config.txt, this script is useless.

## cpu-config.sh

This script sets CPU some values.

Usage:

```
./cpu-config.sh option
```

option:
 - performance; Set to governor performance.
 - ondemand; Set to governor ondemand and up_threshold to 95, sampling_down_factor to 85.
 - default; Set to governor ondemand and up_threshold to 50, sampling_down_factor to 50.

For example you can set crontab -e like following.

```
@reboot    /home/pi/script/path/cpu-config.sh ondemand
```


## raspi-stat.sh

This script show status of Raspberry Pi 3. Status are OS name, version, CPU info, memory info, voltage. CPU info contains arm and core clock, temperature, governor, up threshold if governor is ondemand like that.

ondemand

```
==== OS ======  ==================
Name            Raspbian GNU/Linux
Version         8 (jessie)
==== CPU =====  ==================
Clock arm       600000000Hz
Clock core      250000000Hz
CPU Temp        54.7 C
GPU Temp        55.3'C
Governor        ondemand
UP threshold    95
Down threshold  85
==== Mem =====  ==================
Mem arm         880M
Mem gpu         128M
==== Volt ====  ==================
core            volt=1.2000V
sdram_c         volt=1.2000V
sdram_i         volt=1.2000V
sdram_p         volt=1.2250V
==============  ==================
```

performance

```
==== OS ======  ==================
Name            Raspbian GNU/Linux
Version         8 (jessie)
==== CPU =====  ==================
Clock arm       1200000000Hz
Clock core      250000000Hz
CPU Temp        59.9 C
GPU Temp        59.4'C
Governor        performance
==== Mem =====  ==================
Mem arm         880M
Mem gpu         128M
==== Volt ====  ==================
core            volt=1.2000V
sdram_c         volt=1.2000V
sdram_i         volt=1.2000V
sdram_p         volt=1.2250V
==============  ==================
```


## License

MIT


## Author

tkumata
