# setCPUandMouse.sh
a startup script for automated powerplan setting and clock speed setting, can also disable mouse acceleration

### Information
This script has 2 modes that can be used. User input based execution mode and automated execution mode.

To run the script u need to set either 1 or 3 parameters based on what mode u want to use.

### User input based execution mode
as the name suggests in this mode every step will ask the user for input, useful if run manually

To execute the script in this mode run it as follows
```bash
sudo bash /home/beangreen247/autostart_bin/setCPUandMouse.sh user
```

You will be asked a couple questions so answer the as needed.

### Automated execution mode
as for this one, this one is my personal favorite as it will run on its own and can be used in `crontab -e` at startup
```bash
# For example, you can run a backup of all your user accounts
# at 5 a.m every week with:
# 0 5 * * 1 tar -zcf /var/backups/home.tgz /home/
#
# For more information see the manual pages of crontab(5) and cron(8)
#
# m h  dom mon dow   command
@reboot echo "user_password_here" | sudo -S bash /home/beangreen247/autostart_bin/setCPUandMouse.sh auto oem performance
```

### Changing the clock speed limit
To change the clock speed limit look for lines that contain `cpupower frequency-set` and there change the minimum (--min) and maximum (--max) frequency.

To get the desired number to put in, take the desired frequency in GHz and multiply by 1000000.

For example lets say that my desired min frequency is 100 MHz. So I will take that number, convert it to GHz, that would be 0.1 GHz and multiply this by 1000000 to get 100000 as shown in the provided script. The maximum frequency is counted the same way, but here we took the GHz value already (that would be 2.3 GHz) so just multiply it by 1000000 giving us 2300000.

For those interested the `-g` flag sets the cpu governor.

### Prerequisites
Before running the script make it executable just in case
```bash
chmod +x setCPUandMouse.sh
```

And replace the example password `user_password_here` with your root password.

### Execution explained
To explain the execution of the script well it goes basically like this.
1. It installs dependencies in order for the script to work properly. This step is depended on either user input or automated execution. Here you should decide based on what type of kernel you have in your Ubuntu install. For example if you use the regular kernel like I do on my desktop then pick `generic`. But if you run an oem kernel like I do on my laptop that pick `oem`. This can be checked by running this command in the terminal
 	```bash
 	uname -a
 	```
	example output:
	```bash
	Linux IdeaPad-5-14ITL05 5.17.0-1019-oem #20-Ubuntu SMP PREEMPT Tue Sep 27 13:20:28 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
	```
	In the example above we can see a string like `kernel_version-oem` so in this example that is `5.17.0-1019-oem`. Based on this information we have decided to set the kernel type parameter to `oem` in our automation. This can be done in user input execution mode as well. If there is just `5.17.0-1019` then pick `generic`.

2. The third and final parameter to decide on is what performance governor you want to use. In this script there are two modes usable, that being `powersave` or `performance`. This should be self explanatory.

### How to check governor setting
Run this command in the terminal after startup or after script execution
```bash
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
```
example output
```bash
beangreen247@IdeaPad-5-14ITL05:~$ cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
performance
performance
performance
performance
performance
performance
performance
performance
```
### Supported OS's
* Ubuntu 22.04 LTS release
