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

getuserinfo () {
  User=$(uname -n)
  Machine=$(uname -m)
  OS=$(uname -o)
  Kernel=$(uname -sr)
  Hardware=$(uname -i)
  printf "User: $User;\nMachine: $Machine;\nOS: $OS;\nKernel: $Kernel;\nHardware: $Hardware;\n"

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
getpath () {
  Pathct=$(echo $PATH | tr ":" "\n" | wc -l)
  Pathlen=$(echo $PATH | wc -c) # is that extra \n a problem???
  Path=$(echo $PATH)
  # Path=$(echo $PATH | tr ":" "   ")
  echo $Path
  # separate and test each folder
  # for folder in Path check if in vulnpaths
  # loop colon
  currentind=0
  pathschecked=0
  until [ $pathschecked -eq $Pathct ]
  do
    echo $pathschecked
    # instead of echo here we grab the folder, then echo -n it; if in vuln paths then change the color too
    ((pathschecked++))
  done

}

getDrives () {
  applycolor "progress" "work in progress" ${purple}
}

getSoftware () {
  applycolor "progress" "work in progress" ${purple}
}

getProcesses () {
  applycolor "progress" "work in progress" ${purple}
}

getCronjobs () {
  applycolor "progress" "work in progress" ${purple}
}

getServices () {
  applycolor "progress" "work in progress" ${purple}
}

getTimers () {
  applycolor "progress" "work in progress" ${purple}
}

getNetwork () {
  applycolor "progress" "work in progress" ${purple}
}

getUsers () {
  applycolor "progress" "work in progress" ${purple}
}

getSudoSUID () {
  applycolor "progress" "work in progress" ${purple}
}

getCapabilities () {
  applycolor "progress" "work in progress" ${purple}
}

getShellSessions () {
  applycolor "progress" "work in progress" ${purple}
}

getSSH () {
  applycolor "progress" "work in progress" ${purple}
}

getInterestingFiles () {
  applycolor "progress" "work in progress" ${purple}
}

getWritableFiles () {
  applycolor "progress" "work in progress" ${purple}
}

# PROGRAM START
echo -e "${red}ln ${blue}peas${reset}"

echo -e "${red}============ ${blue}System Information ${red}============${reset}"
getuserinfo
getpath

echo -e "${red}============ ${blue}Drives ${red}============${reset}"
getDrives

echo -e "${red}============ ${blue}Installed Software ${red}============${reset}"
getSoftware

echo -e "${red}============ ${blue}Processes ${red}============${reset}"
getProcesses

echo -e "${red}============ ${blue}Scheduled/Cron jobs ${red}============${reset}"
getCronjobs

echo -e "${red}============ ${blue}Services ${red}============${reset}"
getServices

echo -e "${red}============ ${blue}Timers ${red}============${reset}"
getTimers

echo -e "${red}============ ${blue}Network ${red}============${reset}"
getNetwork

echo -e "${red}============ ${blue}Users ${red}============${reset}"
getUsers

echo -e "${red}============ ${blue}SUDO and SUID commands${red}============${reset}"
getSudoSUID

echo -e "${red}============ ${blue}Capabilities ${red}============${reset}"
getCapabilities

echo -e "${red}============ ${blue}Open Shell Sessions ${red}============${reset}"
getShellSessions

echo -e "${red}============ ${blue}SSH ${red}============${reset}"
getSSH

echo -e "${red}============ ${blue}Interesting Files ${red}============${reset}"
getInterestingFiles

echo -e "${red}============ ${blue}Writable Files ${red}============${reset}"
getWritableFiles