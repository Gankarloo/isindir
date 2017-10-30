#!/bin/bash
# is_indir is a way to know if current working directory is in a project folder much like 'git rev-parse --is-inside-work-tree'
# by searching for a predefined file.
# The contents of that file is used to populate PS1

## Variables
# file to search for
ISINDIRFILE=".perl5proj"

# set to non empty value to enable debug output
DEBUG_indir=''

# prints the content of ISINDIRFILE with color coding to use within PS1 if found in current directory or subdirs
__is_indir_ps1() {
  local ISINDIR=''
  if [[ -n $ISINDIRFILE ]]                                                              # if not defined do nothing
  then
      ISINDIR=$(  __is_indir_scan $ISINDIRFILE )                                        # call the scan function
    
    if [[ -n $ISINDIR ]]                                                                # non epmty value means we got a match from the scan function
    then
      local PRECOLOR="\001\033[01;37m\002"                                              # define colors
      local NC="\001\033[00m\002"                                                       # define no colors

      echo -e "\[${PRECOLOR}[${ISINDIR}]${NC}\]"                                        # print the resulting string
    fi
  fi
}

__is_indir_scan() {
  local targetfile
  local LCWD
  targetfile="$1"
  LCWD=$(pwd)

  if [[ -n $targetfile ]]
  then

      [[ -n $DEBUG_indir ]] && echo "looking for this file >> $targetfile <<"
      while [[ $LCWD == "/"* ]];                                                            # loop as long as path is more than a /
      do
            [[ -n $DEBUG_indir ]] && echo "looking in >> $LCWD"
            if [[ -e ${LCWD}/${targetfile} ]]                                               # check if targetfile exists in working directory
                    then
                [[ -n $DEBUG_indir ]] && echo "FOUND IT >>>$LCWD<<< Contains >>>$targetfile<<<"
                            #export ISINDIR=$(cat $LCWD/$INDIR)
                            cat "${LCWD}/${targetfile}"                             # echo contents of targetfile
                            break 2                                                         # all done. break both wile loops
                    fi

            LCWD=${LCWD%/*}                                                                 # did not find targetfile in CWD remove last dir from CWD and try again
      done
  fi
  return
}
