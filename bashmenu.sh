#!/bin/bash

function bashMenu(){
  LOCATION=$1  
  TOTAL_DIRS=`ls -l $LOCATION | grep ^d | awk '{print $9}' | wc -l | tr -d " "` 
  LIST_OF_DIRS=`ls -l $LOCATION | grep ^d | awk '{print $9}' | tr -s "\n" ","`
  
  selection=1
  renderMenu 1 $LIST_OF_DIRS
  while true
  do
  read -sn1 t
  if [ -z "$t" ]; then
    changeDIR $selection $LOCATION $LIST_OF_DIRS
    break
  else
    if [ $t == 'A' ]; then
      selection=$[$selection - 1]
    fi
    if [ $t == 'B' ]; then
      selection=$[$selection + 1]
    fi
    if [ $selection -gt $TOTAL_DIRS ]; then
      selection=$[selection - TOTAL_DIRS]
    fi
    if [ $selection -lt 1 ]; then
      selection=$[TOTAL_DIRS - selection]
    fi
    echo -en "\033["$TOTAL_DIRS"A"
    renderMenu $selection $LIST_OF_DIRS
  fi
  done
}

function renderMenu(){
  tput civis
  stty -echo
  finalMenuToRender=" "
  count=1
  out=`echo $2 | cut -d, -f$count`
  while [ $out ]
  do
    if [ $1 -eq $count ]; then
      finalMenuToRender="$finalMenuToRender[*] $out \n"
    else
      finalMenuToRender="$finalMenuToRender[ ] $out \n"
    fi
    count=$[$count + 1]
    out=`echo $2 | cut -d, -f$count`
  done
  echo -e $finalMenuToRender
  echo -en "\033[1A"
  tput cnorm
  stty echo
}

function changeDIR(){
  count=1
  out=`echo $3 | cut -d, -f$count`
  while [ $out ]
  do
    if [ $1 == $count ]; then
      echo "Switching to $out."
      cd "$2$out"
    fi
    count=$[$count + 1]
    out=`echo $3 | cut -d, -f$count`
  done
}