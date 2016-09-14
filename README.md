# Raspberry Pi 3 Some Tools

## cpu_config.sh

This script set up threshold of CPU when governor is ondemand. Default is 50 at booting up. Then system default is 95. Both values are an extreme very much. So CPU become hotter than OS is wheezy. Or perfomance is bad. This script set to 70. I seem this value is good.
BTW default governor on jessie kernel 4.4.20 is ondemand.

For example you can set crontab like following.
```
@reboot    /home/pi/script/path/cpu_config.sh
```


## raspi-stat.sh

This script show status of Raspberry Pi 3. Status are OS name, version, CPU info, memory info, voltage. CPU info contains arm and core clock, temperature, governor, up threshold if governor is ondemand like that.

```
== OS ======  ==================
Name          Raspbian GNU/Linux
Version       8 (jessie)
== CPU =====  ==================
Clock arm     600000000Hz
Clock core    250000000Hz
Temperature   51.5'C
Governor      ondemand
UP threshold  70%
== Mem =====  ==================
Mem arm       880M
Mem gpu       128M
== Volt ====  ==================
core          volt=1.2000V
sdram_c       volt=1.2000V
sdram_i       volt=1.2000V
sdram_p       volt=1.2250V
============  ==================
```


## License

MIT


## Author

tkumata
