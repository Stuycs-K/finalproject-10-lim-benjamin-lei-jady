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
  file=$(ls -ld $1)
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
        echo $currentfolder
        # instead of echoing the folder, save to list? or at least check if it's a vulnerable one
        ## pick up here -- check writable
        
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
  test=$(ls -l /etc/profile /etc/profile.d/)

  test=$(cat /etc/shadow /etc/shadow- /etc/shadow~ /etc/gshadow /etc/gshadow- /etc/master.passwd /etc/spwd.db /etc/security/opasswd 2>/dev/null)
  if [[ "${#test}" != 0 ]]; then
    echo "shadow/password files are readable"
  fi
  applycolor "progress" "work in progress" ${bold}
}

getWritableFiles () {
  applycolor "progress" "work in progress" ${bold}
}

# PROGRAM START
echo -e "${red}ln ${blue}peas${reset}"

echo -e "${red}============ ${blue}System Information ${red}============${reset}"
getuserinfo
getpath
#
# echo -e "${red}============ ${blue}Drives ${red}============${reset}"
# getDrives

# echo -e "${red}============ ${blue}Installed Software ${red}============${reset}"
# getSoftware
#
# echo -e "${red}============ ${blue}Processes ${red}============${reset}"
# getProcesses
#
# echo -e "${red}============ ${blue}Scheduled/Cron jobs ${red}============${reset}"
# getCronjobs
#
# echo -e "${red}============ ${blue}Services ${red}============${reset}"
# getServices
#
# echo -e "${red}============ ${blue}Timers ${red}============${reset}"
# getTimers
#
# echo -e "${red}============ ${blue}Network ${red}============${reset}"
# getNetwork
#
# echo -e "${red}============ ${blue}Users ${red}============${reset}"
# getUsers
#
# echo -e "${red}============ ${blue}SUDO and SUID commands${red}============${reset}"
# getSudoSUID
#
# echo -e "${red}============ ${blue}Capabilities ${red}============${reset}"
# getCapabilities
#
# echo -e "${red}============ ${blue}Open Shell Sessions ${red}============${reset}"
# getShellSessions
#
# echo -e "${red}============ ${blue}SSH ${red}============${reset}"
# getSSH

echo -e "${red}============ ${blue}Interesting Files ${red}============${reset}"
getInterestingFiles

echo -e "${red}============ ${blue}Writable Files ${red}============${reset}"
getWritableFiles
