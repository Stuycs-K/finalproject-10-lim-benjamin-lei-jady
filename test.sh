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
checkpermissions "../finalproject/"
checkpermissions ""

Rootuser="root"
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
  lst=("/etc/hostname" "/etc/hosts" "/etc/resolv.conf" "/etc/inetd.conf" "/etc/xinetd.conf")
  for fname in lst
  do
    text=$(cat $fname 2>/dev/null)
    if [ ! $text = "" ]; then
      
    fi
  done

  dnsdomainname
  #Content of /etc/inetd.conf & /etc/xinetd.conf

  #Interfaces
  cat /etc/networks
  (ifconfig || ip a)

  #Neighbours
  (arp -e || arp -a)
  (route || ip n)

  #Iptables rules
  (timeout 1 iptables -L 2>/dev/null; cat /etc/iptables/* | grep -v "^#" | grep -Pv "\W*\#" 2>/dev/null)

  #Files used by network services
  lsof -i
  applycolor "progress" "work in progress" ${bold}
}

getUsers () {
  applycolor "progress" "work in progress" ${bold}
}

getSudoSUID () {
  applycolor "progress" "work in progress" ${bold}
}

getCapabilities () {
  applycolor "progress" "work in progress" ${bold}
}

getShellSessions () {
  applycolor "progress" "work in progress" ${bold}
}

getSSH () {
  applycolor "progress" "work in progress" ${bold}
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

  echo "recently modified files:"
  test=$(find / -type f -mmin -5 ! -path "/proc/*" ! -path "/sys/*" ! -path "/run/*" ! -path "/dev/*" ! -path "/var/lib/*" 2>/dev/null)
  echo $test
  if [[ ${#test} == 0 ]]; then
    echo "no SQLite db files found"
  fi
  echo "SQLite db files:"
  test=$(find / -name '*.db' -o -name '*.sqlite' -o -name '*.sqlite3' 2>/dev/null)
  echo $test
  if [[ ${#test} == 0 ]]; then
    echo "no SQLite db files found"
  fi
  echo "hidden files:"
  test=$(find / -type f -iname ".*" -ls 2>/dev/null)
  echo $test
  if [[ ${#test} == 0 ]]; then
    echo "no hidden files found"
  fi
  echo "webfiles:"
  for fname in "/var/www/" "/srv/www/htdocs/" "/usr/local/www/apache22/data/" "/opt/lampp/htdocs/"
  do
    ls -alhR ${fname} 2>/dev/null
  done
  echo "backup files:"
  test=$(find /var /etc /bin /sbin /home /usr/local/bin /usr/local/sbin /usr/bin /usr/games /usr/sbin /root /tmp -type f \( -name "*backup*" -o -name "*\.bak" -o -name "*\.bck" -o -name "*\.bk" \) 2>/dev/null)
  echo $test
  if [[ ${#test} == 0 ]]; then
    echo "no backup files found"
  fi
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

  applycolor "progress" "work in progress" ${bold}
}

getWritableFiles () {
  applycolor "progress" "work in progress" ${bold}
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
echo -e "${green}============ ${blue}Network ${green}============${reset}"
getNetwork
#
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
#
# echo -e "${green}============ ${blue}Writable Files ${green}============${reset}"
# getWritableFiles
