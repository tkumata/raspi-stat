#!/bin/bash
set -e
. /etc/os-release

CPUINFO=""
VOLT=""
RES="===============\t=============================\n"

CPUINFO="${CPUINFO}\nOS\t${PRETTY_NAME}"
CPUINFO="${CPUINFO}\n===============\t=============================\n"
CPUINFO="${CPUINFO}\nCPU Clock\t$(vcgencmd measure_clock arm|cut -d = -f 2)Hz\n"
CPUINFO="${CPUINFO}\nCPU Temperature\t$(vcgencmd measure_temp|cut -d = -f 2)\n"
CPUINFO="${CPUINFO}\n===============\t=============================\n"

for id in core sdram_c sdram_i sdram_p; do
    VOLT="${VOLT}\n$id\t$(vcgencmd measure_volts $id)\n"
done

RES=${RES}`cat << EoS
${CPUINFO}
${VOLT}
EoS
`
RES="${RES}\n===============\t=============================\n"

echo -e ${RES} | column -s $'\t' -t
