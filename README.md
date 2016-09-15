# Raspberry Pi 3 Some Tools

If you set to force_turbo=1 in /boot/config.txt, these scripts are useless.

## cpu-config.sh

This script sets some CPU values.

Usage:

```
./cpu-config.sh option
```

option:

 - performance; Set to governor performance.
 - myondemand; Set to governor ondemand and up_threshold to 95, sampling_down_factor to 85.
 - powersave; Set to governor powersave.
 - ondemand; Set to governor ondemand and up_threshold to 50, sampling_down_factor to 50. This is default for Raspbian jessie.

For example you can set crontab -e like following.

```
@reboot    /home/pi/script/path/cpu-config.sh myondemand
```

I recommend myondemand. And I do not recommend ondemand. Because if up_threshold is 50, cpu freq increase soon very much. Even if device is idling. So temperature also increase.


## raspi-stat.sh

This script show status of Raspberry Pi 3. Statuses are OS name, version, CPU info, memory info, voltage. CPU info contains arm and core clock, temperature, governor, up threshold if governor is ondemand like that.

### myondemand

```
===== OS ======  ==================
Name             Raspbian GNU/Linux
Version          8 (jessie)
===== CPU =====  ==================
Clock arm        600000000Hz
Clock core       250000000Hz
CPU Temperature  51.5 C
GPU Temperature  51.5'C
Governor         ondemand
UP threshold     95
Down threshold   90
===== Mem =====  ==================
Mem arm          944M
Mem gpu          64M
==== Volt =====  ==================
core             volt=1.2000V
sdram_c          volt=1.2000V
sdram_i          volt=1.2000V
sdram_p          volt=1.2250V
===============  ==================
```

### performance

```
===== OS ======  ==================
Name             Raspbian GNU/Linux
Version          8 (jessie)
===== CPU =====  ==================
Clock arm        1200000000Hz
Clock core       400000000Hz
CPU Temperature  53.6 C
GPU Temperature  53.7'C
Governor         performance
===== Mem =====  ==================
Mem arm          944M
Mem gpu          64M
==== Volt =====  ==================
core             volt=1.2000V
sdram_c          volt=1.2000V
sdram_i          volt=1.2000V
sdram_p          volt=1.2250V
===============  ==================
```


## License

MIT


## Author

tkumata
