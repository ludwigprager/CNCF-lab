
function take-down-time() {

  if [ $# -eq 0 ]; then
    echo "${FUNCNAME[0]}: missing parameter"
    exit 1
  fi

  local DIR="$1"
  echo $(date +%s) > $DIR/start.time
}


function print-elapsed-time() {

  if [ $# -eq 0 ]; then
    echo "${FUNCNAME[0]}: missing parameter"
    exit 1
  fi

  local DIR="$1"

  start=$(<${DIR}/start.time)
  now=$(date +%s)
  elapsed=$( echo "$now - $start" | bc -l )
  minutes=$(( elapsed/60 ))
  seconds=$(( elapsed - (minutes * 60) ))
  printf "Time elapsed: $minutes minutes, $seconds seconds\n"
}
