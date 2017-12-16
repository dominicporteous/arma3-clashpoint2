#!/bin/bash

set -e
set -x

mkdir -p "bin"

MISSION_NAME="Clashpoint"
MISSION_FOLDER_NAME="$MISSION_NAME"

while read m; do

  [[ -z "${m// }" ]] && continue;
  
  export MAP=$( echo "$m" | tr -cd 'A-Za-z0-9._-' )
  export MISSION_FOLDER="./build/$MISSION_FOLDER_NAME.$MAP"

  echo -e "Building $MAP..." && echo -en "travis_fold:start:build.map.$MAP\\r"
  
  mkdir -p "$MISSION_FOLDER"
  
  cp -r ./src/* "$MISSION_FOLDER"
  
  #cat "$MISSION_FOLDER/mission.sqm" | envhandlebars | tee "$MISSION_FOLDER/mission.sqm" > /dev/null
  #cat "$MISSION_FOLDER/description.ext" | envhandlebars | tee "$MISSION_FOLDER/description.ext" > /dev/null
  
  ./tools/bin/makepbo "$MISSION_FOLDER" "./bin/$MISSION_NAME.$MAP.pbo"
  
  echo -e "Building $MAP done." && echo -en "travis_fold:end:build.map.$MAP\\r"
  
done < ./build/maplist.txt

echo -en "travis_fold:start:end_debug\\r"
[[ "$DEBUG" != "" ]] && tree -a || exit 0
echo -en "travis_fold:end:end_debug\\r"