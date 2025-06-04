# ln(PEAS)

### What is LinPEAS?  
[LinPeas](https://github.com/peass-ng/PEASS-ng/tree/master/linPEAS) is a script that searches for possible privesc strategies on a machine. Since many of the commands run while trying privesc strategies are the same each time, linPEAS runs them for you and then lists the results it finds important. 
In recreating linPEAS, we found there was a wonderful privesc checklist resource referenced on the linPEAS website that we utilized for our version. This was specifically the [hacktricks wiki](https://book.hacktricks.wiki/en/linux-hardening/linux-privilege-escalation-checklist.html).

## ln(PEAS) -- our version
*Disclaimer: we did not include every area in our checks as some were very far outside the scope of this class.  
**Let's take a look at how we coded this script.**

### System Information
Basic system info: user, machine name, OS, Kernel, hardware, root user, working directory, home directory, group id of our user. Root user is found by checking the owner of /etc/, an important directory generally owned by the admin level user.

### Path
We check for path vulnerabilities by looking at each directory individually. If the directory is 1) in path, 2) owned by an admin user, and 3) writable by other users, it can be used to run a script to obtain admin level access.   
We check this with a while loop and counter variables to keep track of where directory names start and end, checking writability with -w and ownership with stat /etc/.

### Drives
Here we check to see if there are unmounted drives and if so to mount them. We look for any stored credentials in these.

### Software
We use `which` and `dpkg --list` to find useful modules and compilers which might be helpful for performing priv esc exploits later on.

### Processes
This is a short list of the running processes sorted by top memory usage and other metrics.

### Cronjobs
Here we want to go through the root-owned cronjobs and see if there are any vulnerabilities. This could include an unspecified path (relative path), wildcards in a script name (denoted by asterisk), or if you have permissions over the directory referenced in the cronjob.  
For each cronjob (found in `/etc/crontab`) we:
- get the path referenced at the end of the line (with awk)
- check if it's a script (inspect the path ending to see if it ends in .sh, .php, or other extensions)
- if so check if it is a relative path (grep for '/') or a wildcard: both of these are likely vulnerabilities
- warn the user to see if the directory referenced is modificable because this is exploitable by deleting the directory and creating a new directory named the same

### Networks
Firstly we get some basic network information such as hostname, hosts, dns servers, neighboring devices. Some more complex information that we check is interfaces, files used by network services, and open ports (which was formatted with sed for readability).

### Users
Here we scan for all the created users and groups, highlighting ones with admin level usernames. We also can see users with console, currently logged in users, and login history (last 10).

### Sudo/SUID
Like we learned in class, we check sudo -l and suid binaries that can be exploited with [GTFOBins](https://gtfobins.github.io/).

### Shell
Check for open screens and running tmux sessions.

### SSH
We analyze two folders: a hidden file in home called .ssh and an ssh folder in the root directory /etc/. The first folder shows the paths of the ssh keys generated on the machine, and the second folder has information e.g. whether root login is permitted. 

### Interesting Files and Writable Files
Using `find` commands, we check for interesting or writable files that weren't already tested for in previous sections. 
*This takes the longest to run because enumeration takes a long time.
> Interesting files includes various bits of information that may or may not be necessary for the user, including hidden files.  
> Writable files have more potential for vulnerabilities:
- Logrotate: oldversions allow for easy privesc in editing logs.
- Writable Python Libraries: dangerous because editing libraries can allow them to run a command for creating a reverse shell. 

--- 

### Some takeaways from coding in bash
`2>/dev/null/` is awesome because it helps clean up script outputs and remove errors when running commands (especially `find`).  
Regex patterns in an if statement are supported in checking a variable.  
There are built-in if conditions for rwx access of a file.  
A warning for bash though: it is very strict about spaces and will break if statements and loops if not spaced correctly. We found this out in a rough way.