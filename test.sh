#!/bin/bash
arr=()
User=""

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
  echo $Logname
  # echo ${Logname}
  echo $PWD
  echo $Home
}
# getuserinfo

Path=""
vulnpaths=("/home/user", "/usr/bin/bash")
getpath () {
  Pathlen=$(echo $PATH | tr ":" "\n" | wc -l)
  Path=$(echo $PATH | tr ":" "   ")
  echo $Path
  # separate and test each folder
  # for folder in Path check if in vulnpaths
  # loop colon
  # while [  ]
}
getpath
