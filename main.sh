#!/bin/bash

x=$(ls -l | wc -l)
# ls -l > x
# echo $x
if [ "$x" -eq 7 ] ; then
  echo $x
else
  echo mno
fi
