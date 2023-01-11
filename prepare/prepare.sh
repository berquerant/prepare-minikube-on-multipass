#!/bin/bash

set -x

thisd="$(cd $(dirname $0);pwd)"
mountd="/prepare"

instance_name="${INSTANCE_NAME:-minikube}"
instance_cpu="${INSTANCE_CPU:-2}" # minikube requires 2 cpus
instance_memory="${INSTANCE_MEMORY:-4G}" # minikube requires 2 GiB, consider memory for system
instance_disk="${INSTANCE_DISK:-16G}"
instance_timeout_sec="${INSTANCE_TIMEOUT:-1800}" # 30 min

remount() {
    multipass umount "${instance_name}:${mountd}"
    multipass mount "$thisd" "${instance_name}:${mountd}"
}

echo "Prune instance..."
"${thisd}/prune.sh"

echo "Prepare instance..."
multipass launch --cpus "$instance_cpu" --mem "$instance_memory" --disk "$instance_disk" --name "$instance_name" --timeout "$instance_timeout_sec"

echo "Install docker..."
remount
multipass exec --working-directory "$mountd" "$instance_name" "${mountd}/prepare-docker.sh"
multipass restart "$instance_name"

echo "Install minikube..."
remount
multipass exec --working-directory "$mountd" "$instance_name" "${mountd}/prepare-kube.sh"

echo "Check..."
remount
multipass exec --working-directory "$mountd" "$instance_name" "${mountd}/check.sh"
multipass umount "${instance_name}:${mountd}"
echo "Done!"
