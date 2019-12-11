#!/bin/bash

bashMenu(){

  location=$1
  flags="-l"
  if [ $1 == "-a" ]; then
    location=$2
    flags=$flags"a"
  fi

  total_dirs=$(ls $flags $location | grep ^d | awk '{print $9}' | wc -l | tr -d " ") 
  list_of_dirs=$(ls $flags $location | grep ^d | awk '{print $9}' | tr -s "\n" ",")
  
  selection=1
  renderMenu 1 $list_of_dirs
  while true
  do
  read -sn1 t
  if [ -z "$t" ]; then
    changeDIR $selection $location $list_of_dirs
    break
  else
    if [ $t == 'A' ]; then
      selection=$[$selection - 1]
    fi
    if [ $t == 'B' ]; then
      selection=$[$selection + 1]
    fi
    if [ $selection -gt $total_dirs ]; then
      selection=$[selection - total_dirs]
    fi
    if [ $selection -lt 1 ]; then
      selection=$[total_dirs - selection]
    fi
    echo -en "\033["$total_dirs"A"
    renderMenu $selection $list_of_dirs
  fi
  done
}

renderMenu(){
  tput civis
  stty -echo
  finalMenuToRender=" "
  count=1
  out=$(echo $3 | cut -d, -f$count)
  while [ $out ]
  do
    if [ $1 -eq $count ]; then
      finalMenuToRender="$finalMenuToRender[*] $out \n"
    else
      finalMenuToRender="$finalMenuToRender[ ] $out \n"
    fi
    count=$[$count + 1]
    out=$(echo $3 | cut -d, -f$count)
  done
  echo -e $finalMenuToRender
  echo -en "\033[1A"
  tput cnorm
  stty echo
}

changeDIR(){
  count=1
  out=$(echo $3 | cut -d, -f$count)
  while [ $out ]
  do
    if [ $1 == $count ]; then
      echo "Switching to $out."
      echo "$2$out"
      cd "$2$out"
    fi
    count=$[$count + 1]
    out=$(echo $3 | cut -d, -f$count)
  done
}