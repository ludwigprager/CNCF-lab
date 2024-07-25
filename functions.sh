
function take-down-time() {

  if [ $# -eq 0 ]; then
    echo "${FUNCNAME[0]}: missing parameter"
    exit 1
  fi

  local DIR="$1"
  echo $(date +%s) > $DIR/.start.time
}


function print-elapsed-time() {

  if [ $# -eq 0 ]; then
    echo "${FUNCNAME[0]}: missing parameter"
    exit 1
  fi

  local DIR="$1"

  start=$(<${DIR}/.start.time)
  now=$(date +%s)
  elapsed=$( echo "$now - $start" | bc -l )
  minutes=$(( elapsed/60 ))
  seconds=$(( elapsed - (minutes * 60) ))
  printf "Time elapsed: $minutes minutes, $seconds seconds\n"
}

function cluster-exists() {
  local cluster_name=$1
  #local K3D=$(get-k3d-path)
  local K3D=${CKA_BASEDIR}/k3d

  # need a blank after name. Else prefix would work, too.
  COUNT=$(${K3D} cluster list | grep ^${cluster_name}\  | wc -l)
  if [[ $COUNT -eq 0 ]]; then
    # 1 = false
    return 1
  else
    # 0 = true
    return 0
  fi
}

export -f cluster-exists

function kind-cluster-exists() {
  local cluster_name=$1
  local KIND=${CKA_BASEDIR}/kind

#echo KIND: $KIND
#echo cluster_name: $cluster_name
  # need a blank after name. Else prefix would work, too.
  COUNT=$(${KIND} get clusters 2>/dev/null  | grep ^${cluster_name} | wc -l)
#echo "${KIND} cluster list"
#echo COUNT: $COUNT
  if [[ $COUNT -eq 0 ]]; then
    # 1 = false
    return 1
  else
    # 0 = true
    return 0
  fi
}

export -f kind-cluster-exists


#function kubectl() {
#  $CKA_BASEDIR/kubectl
#}
##export -f kubectl
