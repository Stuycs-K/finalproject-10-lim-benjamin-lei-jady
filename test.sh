#!/bin/bash
red="\e[0;91m"
blue="\e[0;94m"
green="\e[0;92m"
white="\e[0;97m"
yellow="\e[0;33m"
purple="\e[0;35m"
cyan="\e[0;36m"
bold="\e[1m"
uline="\e[4m"
reset="\e[0m"

applycolor () {
  # $1 is the word
  # $2 is the total string
  # $3 is the color
  echo -n $2 | sed -E "s/$1.*//g"
  echo -n -e $3$1${reset}
  echo $2 | sed -E "s/.*$1//g"
}

indent () {
  echo $1 | sed "s/\n/\n\t/g"
}
formatFindResult () {
  if [[ ${#1} != 0 ]]; then
    echo $1 | sed "s/ /\n\t/g"
  fi
  if [[ ${#1} == 0 ]]; then
    echo "none found"
  fi
}
formatHeader() {
  echo -e "${bold}$1${reset}"
}

checkpermissions () {
  # $1 is the absolute file/directory path
  file=$(ls -ld $1 2>/dev/null)
  echo $file
  read="-"
  wr="-"
  ex="-"
  if [[ "$1" =~ ^.{7}r.* ]]; then
    read="r"
  fi
  if [[ "$1" =~ ^.{8}w.* ]]; then
    wr="w"
  fi
  if [[ "$1" =~ ^.{9}x.* ]]; then
    ex="x"
  fi
  echo "$read$wr$ex"
}

Rootuser="root"
group=""
getuserinfo () {
  User=$(uname -n)
  Machine=$(uname -m)
  OS=$(uname -o)
  Kernel=$(uname -sr)
  Hardware=$(uname -i)
  Rootuser=$(ls -ld /etc/ | sed -E 's/^[drwx-]+[\r\n\t\f\v ]+[0-9]+[\r\n\t\f\v ]+([a-zA-Z0-9]+).*$/\1/') #owner of /etc/ which should be root perms
  printf "User: $User;\nMachine: $Machine;\nOS: $OS;\nKernel: $Kernel;\nHardware: $Hardware;\nRootuser: $Rootuser;\n"

  # env=$(env)
  Logname=$(env | grep -E "^LOGNAME")
  Logname=${Logname:8}
  PWD=$(env | grep -E "^PWD" | sed -E "s/PWD=//")
  Home=$(env | grep -E "^HOME" | sed -E "s/HOME=//")
  group=$(id -g)
  echo "Group:$group"
  # echo $Logname
  # echo ${Logname}
  # echo $PWD
  # echo $Home
}

Path=""
vulnpaths=("/home/user", "/usr/bin/bash")
ispathinlist () { # arg1 is vulnpaths, arg2 is folder
  len=${#1}
  finished="f"
  for i in {0..$len}
  do
    if [ $1[i] = $2 ]; then
      finished="t"
      break
    fi
  done
  return $finished
}

getpath () {
  Pathct=$(echo $PATH | tr ":" "\n" | wc -l)
  Path=$(echo $PATH)
  Pathlen=${#Path}
  # Path=$(echo $PATH | tr ":" "   ")
  # echo $Path
  # separate and test each folder
  # for folder in Path check if in vulnpaths
  # loop colon
  # echo $Pathlen
  currentind=0
  pathschecked=0
  until [ $pathschecked -eq $Pathct ]
  do
    # echo $pathschecked
    currentfolderlen=0
    # instead of echo here we grab the folder, then echo -n it; if in vuln paths then change the color too
    go="t"
    while [ $go = "t" ]
    do
      # echo $currentfolderlen
      realindex=$(($currentind + $currentfolderlen)) # index we're checking
      curr=${Path:realindex:1} # substring 1

      if [ "$curr" = ":" ] || [ $realindex -eq $Pathlen ]; then # true when end of folder name
        # echo $currentfolderlen
        go="f"
        currentfolder=${Path:currentind:currentfolderlen} # export each to list?
        # echo $currentfolder # we have the folder at this point
        # instead of echoing the folder, save to list? or at least check if it's a vulnerable one
        # check owner:
        ocheck=$(stat /etc/ | grep -E $Rootuser) # if owner rootuser then returns line starting w "Access"
        # check writable
        wrcheck=""

        if [ ! "$ocheck" = "" ]; then # if not empty then it matched rootuser
          wrcheck=$(checkpermissions $currentfolder)
          wrcheck=${wrcheck:1:1} # rwx or smth like r--
        fi

        if [ ! "$ocheck" = "" ] && [ "$wrcheck" = "w" ]; then
          currentfolder=$(applycolor $currentfolder $currentfolder "orange")
        fi
        echo $currentfolder
      fi

      currentfolderlen=$(($currentfolderlen+1))
    done
    ((pathschecked++))
    ((currentind+=currentfolderlen))
    # let "currentind=currentind + 5"
  done

}

getDrives () {
  applycolor "progress" "work in progress" ${bold}
}

getSoftware () {
  applycolor "progress" "work in progress" ${bold}
}

getProcesses () {
  applycolor "progress" "work in progress" ${bold}
}

getCronjobs () {
  # check for commands without set paths
  # check for wildcard injections
  # check for modificable cron scripts executed by rootuser (or directories)
  # can check for frequently run cronjobs -- possible privesc vector
  applycolor "progress" "work in progress" ${bold}
}

getServices () {
  applycolor "progress" "work in progress" ${bold}
}

getTimers () {
  applycolor "progress" "work in progress" ${bold}
}

getNetwork () {
#Hostname, hosts and DNS
#Content of /etc/inetd.conf & /etc/xinetd.conf
  lst=("/etc/hostname" "/etc/hosts" "/etc/resolv.conf" "/etc/inetd.conf" "/etc/xinetd.conf")
  for fname in "${lst[@]}"
  do
    echo $fname
    text=$(cat $fname 2>/dev/null)
    if [ ! "$text" = "" ]; then
      echo -e "${blue}Contents of ${green}$fname: ${reset}"
      echo $text
    fi
  done
  text=$(dnsdomainname 2>/dev/null)
    if [ ! "$text" = "" ]; then # if there is output then print
      echo "DNS domain name: $text"
    fi
  #Interfaces
  echo -e "${green}Interfaces${reset}"
  cat /etc/networks | grep -v "#"
  (ifconfig || ip a)

  #Neighbors
  echo -e "${green}Neighbors${reset}"
  (arp -e || arp -a)
  (route || ip n)

  #Files used by network services
  echo -e "${green}Files used by network services${reset}"
  lsof -i

  #Open ports?
  echo -e "${green}Open Ports?${reset}"
  # Lines: 1-protocol, 4-local address, 5-foreign address, 6-listen, 7-PID
  # echo -e "${blue}TCP${reset}"

  netstat -punta | grep -E "^[tu]" | sed -E "s/^(\w+)\s+[0-9]+\s+[0-9]+\s+([0-9\.:*]+)\s+([0-9\.:*]+)\s+(\w*)\s+(.*)$/\1 PID:\5\t local ip \2 with \4 connection to \3/g" | sort -h -k2
  # 1 4 5
}

getUsers () {
  formatHeader "All users and their groups"
  for i in $(cut -d":" -f1 /etc/passwd 2>/dev/null);do id $i;done 2>/dev/null | sort grep --color "root\|sudo\|adm\|$"
  echo $test
  formatHeader "users with console:"
  cat /etc/passwd 2>/dev/null | grep "sh$" 
  formatHeader "currently logged users:"
  w
  formatHeader "login history (last 10):"
  last | head
  applycolor "progress" "work in progress" ${bold}
}

getSudoSUID () {
  formatHeader "commands executable with sudo:"
  sudo -l 2>/dev/null
  formatHeader "suid binaries:"
  formatFindResult $(find / -perm -4000 2>/dev/null)
}

getCapabilities () {
  applycolor "progress" "(Permanent, due to complexity and unfamiliarity) work in progress" ${bold}
}
getShellSessions () {
  screen -ls 2>/dev/null
  tmux ls 2>/dev/null
}

getSSH () {
  formatHeader "Analyzing SSH Files"
  formatFindResult $(find /etc/ssh/ ~/.ssh/ -name "*.pub*" 2>/dev/null)
  echo $(ls -l ~/.ssh/known_hosts 2>/dev/null)
  formatFindResult $(cat ~/.ssh/known_hosts 2>/dev/null)
  echo $(cat /etc/ssh/sshd_config 2>/dev/null | grep -E "^PermitRootLogin")
  echo $(cat /etc/ssh/sshd_config 2>/dev/null | grep -E "^UsePAM")
  echo $(cat /etc/ssh/sshd_config 2>/dev/null | grep -E "^PasswordAuthentication")
  echo $(cat /etc/ssh/sshd_config 2>/dev/null | grep -E "^PubkeyAuthentication")
  echo $(cat /etc/ssh/sshd_config 2>/dev/null | grep -E "^PermitEmptyPasswords")
}

getInterestingFiles () {
  for fname in "/etc/profile" "/etc/profile" "/etc/passwd"
  do
    test=$(checkpermissions "$fname")
    if [[ ${test:1:1} == 'w' ]]; then
      echo -e "Profile File: ${fname} is ${red}writable${reset}"
    fi
  done

  for fname in "/etc/shadow" "/etc/shadow-" "/etc/shadow~" "/etc/gshadow" "/etc/gshadow-" "/etc/master.passwd" "/etc/spwd.db" "/etc/security/opasswd"
  do
    test=$(checkpermissions "$fname")
    if [[ ${test:0:1} == 'r' ]]; then
      echo -e "Profile File: ${fname} is ${yellow}readable${yellow}"
    fi
  done

  for fname in "/etc/passwd" "/etc/pwd.db" "/etc/master.passwd" "/etc/group"
  do
    test=$(grep -v '^[^:]*:[x\*]' "$fname" 2>/dev/null)
    if [[ ${#test} > 0 ]]; then
      echo -e "Password File: ${fname} has ${red}readable hashes${reset}"
    fi
  done

  for fname in "/tmp" "/var/tmp" "/var/backups" "/var/mail/" "/var/spool/mail/" "/root"
  do
    test=$(checkpermissions "$fname")
    if [[ ${test:0:1} == 'r' ]]; then
      echo -e "Folder: ${fname} is ${yellow}readable${reset}"
    fi
  done

  formatHeader "recently modified files:"
  test=$(find / -type f -mmin -5 ! -path "/proc/*" ! -path "/sys/*" ! -path "/run/*" ! -path "/dev/*" ! -path "/var/lib/*" 2>/dev/null)
  formatFindResult "$test"

  formatHeader "SQLite db files:"
  test=$(find / -name '*.db' -o -name '*.sqlite' -o -name '*.sqlite3' 2>/dev/null)
  formatFindResult "$test"

  formatHeader "hidden files:"
  test=$(find / -type f -iname ".*" 2>/dev/null)
  formatFindResult "$test"

  formatHeader "webfiles:"
  test=""
  for fname in "/var/www/" "/srv/www/htdocs/" "/usr/local/www/apache22/data/" "/opt/lampp/htdocs/"
  do
    ls -alhR ${fname} 2>/dev/null
    test+="$(ls -alhR ${fname} 2>/dev/null)"
  done
  formatFindResult "$test"

  formatHeader "backup files:"
  test=$(find /var /etc /bin /sbin /home /usr/local/bin /usr/local/sbin /usr/bin /usr/games /usr/sbin /root /tmp -type f \( -name "*backup*" -o -name "*\.bak" -o -name "*\.bck" -o -name "*\.bk" \) 2>/dev/null)
  formatFindResult "$test"
  for fname in "~/.bash_profile" "~/.bash_login" "~/.profile" "~/.bashrc" "~/.bash_logout" "~/.zlogin" "~/.zshrc"
  do
    test=$(checkpermissions "$fname")
    if [[ ${test:0:1} == 'r' ]]; then
      echo -e "Shell File: ${fname} is ${red}readable${reset}"
    fi
    if [[ ${test:1:1} == 'w' ]]; then
      echo -e "Shell File: ${fname} is ${red}writable${reset}"
    fi
  done
}

getWritableFiles () {
  formatHeader "potentially writable libraries:"
  test=$(find /usr/lib/ -group $group 2>/dev/null)
  formatFindResult "$test"

  formatHeader "checking logrotate version"
  test=$(logrotate --version | head -n 1 | sed -E "s/logrotate ([0-9]+\.[0-9]+\.[0.9]+).*/\1/g")
  # test=$(logrotate --version)
  version=$(echo $test | sed -E "s/\..*\..*$//g")
  subversion=$(echo $test | sed -E "s/\.([0-9]+)\..*$/\1/g")
  echo "$version $subversion"
  if [[ $version -lt 3 ]]; then
    echo -e "${red} Logrotate is out of date and susceptible to logrotten and privesc${reset}"
  elif [[ $version -lt 4 ]] && [[ $subversion -lt 18 ]]; then
    echo -e "${red} Logrotate is out of date and susceptible to logrotten and privesc${reset}"
  else
    echo "Logrotate version likely fine."
  fi
  echo $test

  test=$(checkpermissions "/etc/sysconfig/network-scripts/")
  if [[ ${test:1:1} == 'w' ]]; then
    echo -e "${red} : /etc/sysconfig/network-scripts/ is writable${reset}"
  fi
  formatHeader "writable network-scripts:"
  test=$(find /usr/lib/ -group $group 2>/dev/null)
  formatFindResult "$test"
}

# PROGRAM START
echo -e "${red}ln ${blue}peas${reset}"

echo -e "${green}============ ${blue}System Information ${green}============${reset}"
getuserinfo
getpath
#
# echo -e "${green}============ ${blue}Drives ${green}============${reset}"
# getDrives

# echo -e "${green}============ ${blue}Installed Software ${green}============${reset}"
# getSoftware
#
# echo -e "${green}============ ${blue}Processes ${green}============${reset}"
# getProcesses
#
# echo -e "${green}============ ${blue}Scheduled/Cron jobs ${green}============${reset}"
# getCronjobs
#
# echo -e "${green}============ ${blue}Services ${green}============${reset}"
# getServices
#
# echo -e "${green}============ ${blue}Timers ${green}============${reset}"
# getTimers
#
# echo -e "${green}============ ${blue}Network ${green}============${reset}"
# getNetwork

# echo -e "${green}============ ${blue}Users ${green}============${reset}"
# getUsers
#
# echo -e "${green}============ ${blue}SUDO and SUID commands${green}============${reset}"
# getSudoSUID
#
# echo -e "${green}============ ${blue}Capabilities ${green}============${reset}"
# getCapabilities
#
# echo -e "${green}============ ${blue}Open Shell Sessions ${green}============${reset}"
# getShellSessions
#
# echo -e "${green}============ ${blue}SSH ${green}============${reset}"
# getSSH

# echo -e "${green}============ ${blue}Interesting Files ${green}============${reset}"
# getInterestingFiles

# echo -e "${green}============ ${blue}Writable Files ${green}============${reset}"
# getWritableFiles
