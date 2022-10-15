#!/bin/bash
#set -x # debugging purposes
echo "params passed > 1st param:$1 2nd param:$2 3rd param:$3"
if [[ "$1" == "user" ]]; then
	#
	#   user input based execution
	#
	echo "before installing dependencies please pick based on your kernel type..."
	echo -e "1)generic\n2)oem"
	read -p 'What option do you want type in the number: ' kernelSelect
	echo "User picked option " $kernelSelect
	echo "please type in your password next"
	read -sp 'Password: ' passVar
	if [[ $kernelSelect == 1 ]]; then
		echo "$passVar" | sudo -S apt install indicator-cpufreq cpufrequtils linux-tools-generic
	elif [[ $kernelSelect == 2 ]]; then
		echo "$passVar" | sudo -S apt install indicator-cpufreq cpufrequtils linux-tools-oem-22.04
	else
		echo "no option selected"
	fi
	echo -e "Select a power setting from the following options"
	echo -e "1)powerseve\n2)performance"
	read -p 'type in the name of the power plan you want to use: ' userPowerInput
	if [[ "$userPowerInput" == "powersave" ]]; then
		# powersave mode
		echo "$passVar" | sudo -S echo powersave | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
		echo "$passVar" | sudo -S cpufreq-set --governor powersave
		echo "$passVar" | sudo -S sudo cpupower frequency-set --min 100000 --max 1300000 -g powersave
		echo "$passVar" | sudo -S cpupower -c all set --perf-bias 15
		echo "powersave mode executed"
	elif [[ "$userPowerInput" == "performance" ]]; then
		# performance mode
		echo "$passVar" | sudo -S echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
		echo "$passVar" | sudo -S cpufreq-set --governor performance
		echo "$passVar" | sudo -S sudo cpupower frequency-set --min 2300000 --max 2300000 -g performance
		echo "$passVar" | sudo -S cpupower -c all set --perf-bias 0
		echo "performance mode executed"
	else
		echo "no option selected"
	fi
elif [[ "$1" == "auto" ]]; then
	#
	#   automated execution; preferable in scripts and at startup
	#
	passVar="user_password_here"  #here you input your password as a string #might be better to use a base64 hash but this works just fine
	if [[ "$2" == "generic" ]]; then
		echo $passVar | sudo -S apt install indicator-cpufreq cpufrequtils linux-tools-generic
	elif [[ "$2" == "oem" ]]; then
		echo $passVar | sudo -S apt install indicator-cpufreq cpufrequtils linux-tools-oem-22.04
	else
		echo "no 2nd param passed or not a valid option"
	fi
	if [[ "$3" == "powersave" ]]; then
		# powersave mode
		echo $passVar | sudo -S echo powersave | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
		echo $passVar | sudo -S cpufreq-set --governor powersave
		echo $passVar | sudo -S sudo cpupower frequency-set --min 100000 --max 2300000 -g powersave
		echo $passVar | sudo -S cpupower -c all set --perf-bias 15
	elif [[ "$3" == "performance" ]]; then
		# performance mode
		echo $passVar | sudo -S echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
		echo $passVar | sudo -S cpufreq-set --governor performance
		echo $passVar | sudo -S sudo cpupower frequency-set --min 2300000 --max 2300000 -g performance
		echo $passVar | sudo -S cpupower -c all set --perf-bias 0
	else
		echo "no 3rd param passed or not a valid option"
	fi
else
	echo "no params passed at all, closing..."
fi
# setting mouse acc to flat aka disable mouse acc, you may comment out if not wanted
xset m 0 0
echo -e "The script finished executing. You may close the window now...\nThomas Mozdren (https://github.com/BeanGreen247)"
