#!/bin/bash
# ================================================================================
# test_seachest_script.sh - Seagate drive utilities
# Copyright (c) 2016-2018 Seagate Technology LLC and/or its Affiliates, All Rights Reserved
# v0.3
# ================================================================================

# Demonstrates how to scan for drives in the system, pick one to test and then run
# through a series of simple, data-safe SeaChest Utilities tests.

# This script has seven demonstration sections:
#  1 - Device discovery
#  2 - Seagate device detection
#  3 - Display device information
#  4 - Run Short Drive Self Test (DST)
#  5 - Check SMART Status
#  6 - Run a short user definced read scan
#  7 - Result code review

# PLEASE READ THE SEACHEST END USER LICENSE AGREEMENT ("EULA") CAREFULLY.
# DO NOT EXECUTE THIS SCRIPT UNLESS YOU AGREE WITH ALL CONDITIONS.
#

# END USER LICENSE AGREEMENT
# This information is covered by the Seagate End User License Agreement.
# See http://www.seagate.com/legal-privacy/end-user-license-agreement/

#echo ""
#echo "================================================"
#echo "This is an example script using read-only tests."
#echo "================================================"

#=============== Global Variables ============================================
# Date last edit:
DATE_STAMP="21-May-2018"
TITLE="Seagate SeaChest Test Script"

#example below of ANSI quoting
WHITEonBLUE=$'\e[0;37m\e[44m'
WHITEonGREEN=$'\e[0;37m\e[42m'
WHITEonRED=$'\e[0;37m\e[41m'
BLACKonBLUE=$'\e[0;30m\e[44m'
BLACKonGREEN=$'\e[0;30m\e[42m'
BLACKonRED=$'\e[0;30m\e[41m'
RESETCOLOR=$'\e[0m'

#Latest versions
#Below are the Linux 32-bit versions used with Tiny Core Linux
#SEACHEST_BASICS="SeaChest_Basics_271_1177_32"
#SEACHEST_GENERICTESTS="SeaChest_GenericTests_171_1177_32"
#SEACHEST_SMART="SeaChest_SMART_191_1177_32"
SEACHEST_BASICS="SeaChest_Basics"
SEACHEST_GENERICTESTS="SeaChest_GenericTests"
SEACHEST_SMART="SeaChest_SMART"

DRIVE_DATA_ARRAY=()

# Details for current drive in test
CURRENT_IF=""
CURRENT_DEV=""
CURRENT_MN=""
CURRENT_SN=""
CURRENT_FW=""

#=============== Function Declarations ========================================
function repecho() {
  # draws the separator line
  local rep_count=$1;
  local rep_char=$2;

  for ((i=1; i <= $rep_count; i++)); do
    echo -n "$rep_char";
  done
  echo;
}

#------------------------------------------------------
function display_result () {
  local local_result

  local_result=$1;
  if [[ $local_result -ne 0 ]]; then
    clear;
#    echo -n "This step FAILED or ended with Result Code: $local_result = " | sed $'s/FAILED/\033[0;37m\033[41m&\033[0m/';
    echo -n "This step FAILED or ended with Result Code: $local_result = " | sed $"s/FAILED/${BLACKonRED}&${RESETCOLOR}/";
    case "$local_result" in
      1)  echo -ne $WHITEonBLUE"Error in command line options";;
      2)  echo -ne $WHITEonBLUE"Invalid Device Handle or Missing Device Handle";;
      3)  echo -ne $WHITEonBLUE"Operation Failure";;
      4)  echo -ne $WHITEonBLUE"Operation not supported";;
      5)  echo -ne $WHITEonBLUE"Operation Aborted";;
      6)  echo -ne $WHITEonBLUE"File Path Not Found";;
      7)  echo -ne $WHITEonBLUE"Cannot Open File";;
      8)  echo -ne $WHITEonBLUE"File Already Exists";;
      *)  echo -ne $WHITEonBLUE"Unknown";;
    esac
    echo -e $RESETCOLOR;
    repecho 79 =;
    sleep 5;
    echo "";
    fbv -u -i -c ../FAIL.png
    exit 1
  else
    if [[ $local_result -eq 0 ]]; then
#      echo "This step PASSED or ended with Result Code: $local_result = No Error Found" | sed $'s/PASSED/\e[0;37m \e[42m &\e[0m/';
      echo -n "This step PASSED or ended with Result Code: $local_result = " | sed $"s/PASSED/${BLACKonGREEN}&${RESETCOLOR}/";
      echo -ne $WHITEonBLUE"No Error Found";
      echo -e $RESETCOLOR;
    fi
  fi
}

#------------------------------------------------------
function populate_drive_data () {
  # extracts only the modern Seagate model numbers to array.
  # MODELS="$($APP_NAME -i | grep "ST[0-9]" | tr -s " " | cut -d" " -f4)"
  # All drives even if not Seagate, all data
  # DRIVE_DATA_ARRAY=($($APP_NAME -i | grep "MN:" | tr -s " "))

  # Just Seagate drives, all data
  DRIVE_DATA_ARRAY=($($SEACHEST_BASICS -s | grep "ST[0-9]" | tr -s " "));
}

#------------------------------------------------------
function show_selected_drive_info () {
  local n_elements max_index

  # number of elements in the array
  # echo ${#DRIVE_DATA_ARRAY[@]};
  echo "Testing the following drive:"
  echo ""
  ((n_elements=${#DRIVE_DATA_ARRAY[@]}, max_index=n_elements - 1));
  for ((i = 0; i <= max_index; i++)); do
    if [[ ${DRIVE_DATA_ARRAY[i]} == "/dev/sg$sg_dev" ]]; then
      # show interface or vendor
      CURRENT_IF=${DRIVE_DATA_ARRAY[i-1]};
      echo "interface: $CURRENT_IF      ";
      # show device handle
      CURRENT_DEV=${DRIVE_DATA_ARRAY[i]};
      echo "device:    $CURRENT_DEV";
      # show model number
      CURRENT_MN=${DRIVE_DATA_ARRAY[i+1]};
      echo "model:     $CURRENT_MN";
      # show serial number
      CURRENT_SN=${DRIVE_DATA_ARRAY[i+2]};
      echo "serial:    $CURRENT_SN";
      # show firmware rev
      CURRENT_FW=${DRIVE_DATA_ARRAY[i+3]};
      echo "firmware:  $CURRENT_FW";
    fi
  done
}

#=============== Main =========================================================
clear;
echo $0;
echo "$TITLE    ver: $DATE_STAMP";
echo ""
if [ $# -ne 1 ]; then
  $SEACHEST_BASICS --scan;
  echo "";
  echo "Usage: Type ./test_seachest_script.sh # where # is the /dev/sg# you want to test.";
  echo "";
  exit 1;
fi

sg_dev=$1;

populate_drive_data;

#./$SEACHEST_BASICS -s | grep "ST[0-9]" | tr -s " " | cut -d" " -f3
repecho 79 =;
show_selected_drive_info $sg_dev;
echo "";
read -r -n1 -p "Press a key to continue.... " jnk;
echo "";
$SEACHEST_BASICS -d /dev/sg$sg_dev --deviceInfo --echoCommandLine;
display_result $?;
repecho 79 =;

echo "";
$SEACHEST_SMART -d /dev/sg$sg_dev --shortDST --poll --echoCommandLine;
display_result $?;
repecho 79 =;

echo "";
$SEACHEST_SMART -d /dev/sg$sg_dev --smartCheck --echoCommandLine;
display_result $?;
repecho 79 =;

echo "";
$SEACHEST_GENERICTESTS -d /dev/sg$sg_dev --userGenericStart 100000 --userGenericRange 250000 --echoCommandLine;
sleep 5;
clear;
display_result $?;
repecho 79 =;
echo "";
fbv -u -i -c ../PASS.png

# http://unix.stackexchange.com/questions/32290/pass-command-line-arguments-to-bash-script
# http://codegolf.stackexchange.com/questions/93707/draw-an-ascii-rectangle  so I do not lose this to read later
# http://stackoverflow.com/questions/12974162/extract-numbers-from-a-string-using-sed-and-regular-expressions
