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

  env=$(env)
  Logname=$(env | grep -E "^LOGNAME")
  Logname=${Logname:8}
  PWD=$(env | grep -E "^PWD" | tr -d "PWD=")
  Home=$(env | grep -E "^HOME" | tr -d "HOME=")
  echo $Logname
  # echo ${Logname}
  echo $PWD
  echo $Home
}
getuserinfo
