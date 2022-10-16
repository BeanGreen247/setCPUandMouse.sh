#!/bin/bash
set -x # debugging purposes
mainForm () {
ENTRY=`zenity --forms --title="System Power Plan settings" --text="Settings" \
   --add-entry="Kernel Type" \
   --add-entry="Power Mode" \
   --add-password="Password" \
   --extra-button Help`
passVar="`echo $ENTRY | cut -d'|' -f3`"
}
main () {
if [[ "`echo $ENTRY | cut -d'|' -f1`" == "generic" ]]; then
	echo $passVar | sudo -S apt install indicator-cpufreq cpufrequtils linux-tools-generic
elif [[ "`echo $ENTRY | cut -d'|' -f1`" == "oem" ]]; then
	echo $passVar | sudo -S apt install indicator-cpufreq cpufrequtils linux-tools-oem-22.04
else
	echo "no valid kernel chosen"
fi
if [[ "`echo $ENTRY | cut -d'|' -f2`" == "powersave" ]]; then
	# powersave mode
	echo $passVar | sudo -S echo powersave | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
	echo $passVar | sudo -S cpufreq-set --governor powersave
	echo $passVar | sudo -S sudo cpupower frequency-set --min 100000 --max 2300000 -g powersave
	echo $passVar | sudo -S cpupower -c all set --perf-bias 15
elif [[ "`echo $ENTRY | cut -d'|' -f2`" == "performance" ]]; then
	# performance mode
	echo $passVar | sudo -S echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
	echo $passVar | sudo -S cpufreq-set --governor performance
	echo $passVar | sudo -S sudo cpupower frequency-set --min 2300000 --max 2300000 -g performance
	echo $passVar | sudo -S cpupower -c all set --perf-bias 0
else
	echo "no power plan chosen"
fi
if [[ $? == 1 ]]; then
    2&>/dev/null
else
    2&>/dev/null
fi
# setting mouse acc to flat aka disable mouse acc, you may comment out if not wanted
xset m 0 0
}
mainForm
if [[ "$(echo $ENTRY)" == "Help" ]]; then
    zenity --info --title 'Info' --text 'Kernel Type: oem|generic\nPower Mode: powersave|performance\nPassword: root password'
    mainForm
    main
fi
main
if [[ $? == 1 ]]; then
    2&>/dev/null
else
    2&>/dev/null
fi
# setting mouse acc to flat aka disable mouse acc, you may comment out if not wanted
xset m 0 0
