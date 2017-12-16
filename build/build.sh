#!/bin/bash

set -e

MISSION_NAME="Clashpoint"
MISSION_FOLDER_NAME="$MISSION_NAME"

while read m; do

  [[ -z "${m// }" ]] && continue;
  
  MAP=$( echo "$m" | tr -cd 'A-Za-z0-9._-' )
  MISSION_FOLDER="./build/$MISSION_FOLDER_NAME.$MAP"

  echo -e "Building $MAP...";
  
  mkdir -p "$MISSION_FOLDER" > /dev/null
  
  cp -r ./src/* "$MISSION_FOLDER" > /dev/null
  
  cat "$MISSION_FOLDER/mission.sqm" | envhandlebars | tee "$MISSION_FOLDER/mission.sqm" > /dev/null
  cat "$MISSION_FOLDER/description.ext" | envhandlebars | tee "$MISSION_FOLDER/description.ext" > /dev/null
  
  ./tools/bin/makepbo "$MISSION_FOLDER" "./bin/$MISSION_NAME.$MAP.pbo" > /dev/null
  
  echo -e "Building $MAP done.";
  
done < ./build/maplist.txt

[[ "$DEBUG" != "" ]] && tree -a || exit 0