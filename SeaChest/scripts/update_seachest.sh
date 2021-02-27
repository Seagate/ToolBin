#!/bin/bash
# ================================================================================
# update_seachest.sh - Seagate drive utilities
# Copyright (c) 2019 Seagate Technology LLC and/or its Affiliates, All Rights Reserved
# v0.1 initial release
# v0.2 now pointing to github, added MD5 check
# v0.3 now basing update on build date instead of versions
# v0.4 need to support old and new --version layouts with multiple libraries
# ================================================================================

# Demonstrates how to check for updates
# Exit levels:
# 0 You have the latest version or Download successful. 
# 1 Command help
# 2 There was a problem with the download. The file may be invalid.
# 3 Download declined
# 4 No matching application name found in the update data.
# 5 Application not found
# 6 MD5 mismatch

#=============== Global Variables ============================================
# Date last edit
EDIT_STAMP="18-Sep-2019"
TITLE="SeaChest Utilities Update Script"
SC_UPDATE_PATH="https://raw.githubusercontent.com/Seagate/ToolBin/master/SeaChest/";
SC_UPDATE_FILE="seachestupdate.json";
SC_UPDATE_URL=$SC_UPDATE_PATH$SC_UPDATE_FILE;

#example below of ANSI quoting
WHITEonBLUE=$'\e[1;37m\e[44m'
WHITEonGREEN=$'\e[1;37m\e[42m'
WHITEonRED=$'\e[1;37m\e[41m'
BLACKonBLUE=$'\e[1;30m\e[44m'
BLACKonGREEN=$'\e[1;30m\e[42m'
BLACKonRED=$'\e[1;30m\e[41m'
YELLOW=$'\e[1;33m'

RESETCOLOR=$'\e[0m'

# Details for current app to check
CUR_APP_ARRAY=""
CUR_APP_NAME=""
CUR_APP_VER=""
CUR_APP_LIB=""
CUR_APP_DATE=""
CUR_APP_REV=""
CUR_APP_ARCH=""
CUR_APP_OS=""

JSON_DATA_ARRAY=();
UPD_APP_NAME=""
UPD_APP_DATE=""
UPD_APP_REV=""
UPD_APP_PATH=""
UPD_APP_OS=""
UPD_APP_FILE=""
UPD_APP_URL=""

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
function populate_current_app_data() {
  local app=$1;
  local verbose_ver="";

  CUR_APP_ARRAY=($($app --version --verbose 0));
  if [[ $? -eq 127 ]]; then
     echo "Application $app not found";
     exit 5;
  fi

  #printf '%s\n' "${CUR_APP_ARRAY[@]}"

  ((n_elements=${#CUR_APP_ARRAY[@]}, max_index=n_elements - 1));    
  for ((i = 0; i <= max_index; i++)); do
     if [ ${CUR_APP_ARRAY[i]} = "Library" ]; then
        verbose_ver=OLD;
     fi
  done
  
  if [[ "$verbose_ver" = "OLD" ]]; then
     #echo "Library found!! OLD version";
     CUR_APP_NAME=${CUR_APP_ARRAY[3]};
     CUR_APP_NAME=($(echo "${CUR_APP_NAME//:}"));
     CUR_APP_VER=${CUR_APP_ARRAY[6]};
     CUR_APP_LIB=${CUR_APP_ARRAY[9]};
     CUR_APP_LIB=($(echo "$CUR_APP_LIB" | tr '.' '_'));
     CUR_APP_DATE=${CUR_APP_ARRAY[12]}"-"${CUR_APP_ARRAY[13]}"-"${CUR_APP_ARRAY[14]};
     CUR_APP_REV=$CUR_APP_VER-$CUR_APP_LIB;
     CUR_APP_ARCH=${CUR_APP_ARRAY[17]};
     CUR_APP_OS=${CUR_APP_ARRAY[31]};
  else
     #echo "Library not found!! NEW version";
     CUR_APP_NAME=${CUR_APP_ARRAY[3]};
     CUR_APP_NAME=($(echo "${CUR_APP_NAME//:}"));
     CUR_APP_VER=${CUR_APP_ARRAY[6]};
     CUR_APP_LIB=${CUR_APP_ARRAY[12]};
     CUR_APP_LIB=($(echo "$CUR_APP_LIB" | tr '.' '_'));
     CUR_APP_DATE=${CUR_APP_ARRAY[18]}"-"${CUR_APP_ARRAY[19]}"-"${CUR_APP_ARRAY[20]};
     CUR_APP_REV=$CUR_APP_VER-$CUR_APP_LIB;
     CUR_APP_ARCH=${CUR_APP_ARRAY[23]};
     CUR_APP_OS=${CUR_APP_ARRAY[37]};
  fi
}

#------------------------------------------------------
function download_update_data() {
  echo "Checking for updates ...";
  echo "";
  #echo $SC_UPDATE_URL;
  curl $SC_UPDATE_URL > $SC_UPDATE_FILE;
  echo ""
}

#------------------------------------------------------
function populate_update_data() {
  JSON_DATA_ARRAY=( $(sed -n '/{/,/}/{s/[^:]*:[^"]*"\([^"]*\).*/\1/p;}' $SC_UPDATE_FILE) );

  # above shows how to read a json file into a bash array
  # see https://stackoverflow.com/questions/38364261/parse-json-to-array-in-a-shell-script for examples
  # various ways to study the array data
  # echo ${JSON_DATA_ARRAY[@]};
  # print the contents of the array
  # printf '%s\n' "${JSON_DATA_ARRAY[@]}"
}

#------------------------------------------------------
function check_update_data () {
  local n_elements max_index

  # number of elements in the array
  # echo ${#JSON_DATA_ARRAY[@]};

  ((n_elements=${#JSON_DATA_ARRAY[@]}, max_index=n_elements - 1));
  for ((i = 0; i <= max_index; i++)); do
     if [[ ${JSON_DATA_ARRAY[i]} == "$CUR_APP_NAME" ]]; then
        # match the current app to the update data
        #echo $i;
        UPD_APP_NAME=${JSON_DATA_ARRAY[i]};
        UPD_APP_REV=${JSON_DATA_ARRAY[i+1]};
        UPD_APP_DATE=${JSON_DATA_ARRAY[i+2]};

        if [[ $CUR_APP_OS == "Windows" ]]; then
           UPD_APP_OS=${JSON_DATA_ARRAY[i+3]};
           if [[ $CUR_APP_ARCH == "X86" ]]; then
             UPD_APP_FILE=${JSON_DATA_ARRAY[i+4]}
           elif [[ $CUR_APP_ARCH == "X86_64" ]]; then
             UPD_APP_FILE=${JSON_DATA_ARRAY[i+5]}
           fi
        elif [[ $CUR_APP_OS=="Linux" ]]; then
           UPD_APP_OS=${JSON_DATA_ARRAY[i+6]};
           if [[ $CUR_APP_ARCH == "X86" ]]; then
             UPD_APP_FILE=${JSON_DATA_ARRAY[i+7]}
           elif [[ $CUR_APP_ARCH == "X86_64" ]]; then
             UPD_APP_FILE=${JSON_DATA_ARRAY[i+8]}
           fi
        fi
     fi
  done
  if test -z "$UPD_APP_NAME"; then
     echo -ne $WHITEonRED"No matching application name found in the update data."; echo -e $RESETCOLOR
     echo "";
     exit 4
  fi
  UPD_APP_PATH=${JSON_DATA_ARRAY[max_index]};
  echo -ne $YELLOW"Latest:"$RESETCOLOR;
  echo "";
  echo "$UPD_APP_NAME   $UPD_APP_REV   $CUR_APP_OS   $CUR_APP_ARCH   $UPD_APP_DATE";
  # change CUR_APP_REV to test download
  #CUR_APP_REV="foo";
  tmpCurAppDate=$(date --date=$CUR_APP_DATE +%s);
  #echo $tmpCurAppDate;
  tmpUpdAppDate=$(date --date=$UPD_APP_DATE +%s);
  #echo $tmpUpdAppDate;
  #if [[ $CUR_APP_REV == $UPD_APP_REV ]]; then
  if [[ $tmpCurAppDate -eq $tmpUpdAppDate ]]; then
     echo -ne $WHITEonBLUE"Your copy of $CUR_APP_NAME is up to date."; echo -e $RESETCOLOR
  elif [[ $tmpCurAppDate -lt $tmpUpdAppDate ]]; then
     echo -ne $WHITEonBLUE"Your copy of $CUR_APP_NAME is old."; echo -e $RESETCOLOR
     UPD_APP_URL=$UPD_APP_PATH$UPD_APP_OS$UPD_APP_FILE
  elif [[ $tmpCurAppDate -gt $tmpUpdAppDate ]]; then
     echo -ne $WHITEonBLUE"Your copy of $CUR_APP_NAME is actually newer than the available update."; echo -e $RESETCOLOR
  fi
  # echo $CUR_APP_REV;
  # echo $UPD_APP_REV;
  # echo $UPD_APP_URL;
  echo "";
  # check if we found a file to assign to the file variable, returns false if empty
  test -n "$UPD_APP_URL";
}

#------------------------------------------------------
function check_md5 () {
  local test_md5 hash_md5

  test_md5=$(md5sum $1);
  echo "Checking MD5: "$test_md5;
  test_md5=$(echo $test_md5  | { read -a array; echo ${array[0]}; });
  hash_md5=$(grep 'MD5' $1".hash.txt" | { read -a array; echo ${array[1]}; });
  echo -ne "Expected MD5: "$hash_md5"  "$WHITEonRED;
  if [[ $test_md5 == ${hash_md5,,} ]]; then
    echo "Match!"$RESETCOLOR;
    rm $1".hash.txt"
    echo ""
  else
    echo "Not a match!"$RESETCOLOR;
    rm $1*;
    echo "";
    exit 6
  fi
}

#=============== Main =========================================================
#clear;
#echo $0 $1;
echo "";
echo "$TITLE                               ver: $EDIT_STAMP";
repecho 40 -=;
echo "";
if [[ $# -ne 1  || ( $1 == "--help" || $1 == "-help" || $1 == "-h") ]]; then
  echo -ne "Usage:   "$WHITEonBLUE"./update_seachest.sh"$RESETCOLOR" "$BLACKonGREEN"<SeaChest app name>"; echo -e $RESETCOLOR
  echo "";
  echo -ne "Example: "$WHITEonBLUE"./update_seachest.sh"$RESETCOLOR" "$WHITEonRED"SeaChest_Basics_280_11923_64"; echo -e $RESETCOLOR
  echo "";
  exit 1;
fi

sc_app=$1;

populate_current_app_data $sc_app;

echo -ne $YELLOW"Current:"$RESETCOLOR;
echo "";
#CUR_APP_NAME="SomeTestNameDoesn'tMatter";
echo "$CUR_APP_NAME   $CUR_APP_REV   $CUR_APP_OS   $CUR_APP_ARCH   $CUR_APP_DATE";
#echo $CUR_APP_VER;
#echo $CUR_APP_LIB;
echo "";

download_update_data;
populate_update_data;

if check_update_data; then
   echo -ne $YELLOW"Newer?: "$RESETCOLOR; echo -ne $BLACKonRED"Yes, at this link..."; echo -e $RESETCOLOR;

   #echo "$UPD_APP_NAME   $UPD_APP_REV   $CUR_APP_OS   $CUR_APP_ARCH";
   echo $UPD_APP_URL;
   echo ""
   read -p "Download the update? Y/N " -n 1 -r;
   echo
   if [[ $REPLY =~ ^[Yy]$ ]]; then
      curl -RJ --remote-name-all {$UPD_APP_URL,$UPD_APP_URL".hash.txt"};
      echo "";
      if [[ $? -ne 0 ]]; then
         echo "There was a problem with the download. The file may be invalid.";
         exit 2;
      else
         check_md5 ./$UPD_APP_FILE;
         echo -ne $BLACKonGREEN"Download successful."$RESETCOLOR$YELLOW" Here is the version information from the new download:"; echo -e $RESETCOLOR;
         (./$UPD_APP_FILE --version);
         echo "Thank you for using SeaChest Utilities.";
      fi
   else
      echo "You didn't say yes."
      exit 3;
   fi
else
   echo -ne $YELLOW"Newer?: "$RESETCOLOR; echo -ne $BLACKonGREEN"Not at this time."; echo -e $RESETCOLOR;
fi
echo "";
# check if we found a file to assign to the file variable, returns exit code 1 if empty
test -n "$UPD_APP_URL";
