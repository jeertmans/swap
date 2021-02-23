#!/bin/bash

# TODO: Parse more arguments (other than files) and check that files / folders exist
# e.g.: add verbose mode
FILES=()
for FILE in $@; do
  FILES+=("$FILE")
done

# TODO: move rotation here
function rotate {
  local S=$1
  shift
  local ARRAY=$@
  local LEN=${#ARRAY[@]}
  local N=$(($LEN-$S))
  ARRAY=("${ARRAY[@]:$N}" "${ARRAY[@]:0:$N}")
  echo $ARRAY
}

DIR="$(mktemp -d)"

TMP_FILES=()

for FILE in $@; do
  TMP_FILE="$(mktemp -p $DIR)"
  #echo "Moved" $FILE "to" $TMP_FILE$
  mv $FILE $TMP_FILE
  touch $FILE
  TMP_FILES+=("$TMP_FILE")
done


LEN=${#FILES[@]}
N=$(($LEN-1))
FILES=("${FILES[@]:N}" "${FILES[@]:0:N}")
#echo "Rotated file"
#echo ${FILES[*]}

for ((I=0;I<LEN;I++)); do
  FILE=${FILES[I]}
  TMP_FILE=${TMP_FILES[I]}
  #echo "Moving" $TMP_FILE "to" $FILE
  mv $TMP_FILE $FILE
done

# Clearing temp. files
rm -rf $DIR
