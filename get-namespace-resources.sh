#!/bin/bash

namespace=$1
backup_dir=backup
declare -a resources=("secrets" "svc" "ing" "deployments" "ds")

mkdir -p $backup_dir/namespace
kubectl get ns/${namespace} -o yaml --export > $backup_dir/namespace/${namespace}.yaml
for r in "${resources[@]}"
do
    echo exporting $r
    echo "==================="
    mkdir -p $backup_dir/$r
    out=$(kubectl $r -n ${namespace} -o jsonpath='{.items[*].metadata.name}')
    for i in $out
    do
        if [[ $i != *"token"* ]]; then
            echo "exporting" $r/$i
            kubectl get $r/$i -n ${namespace} -o yaml --export > $backup_dir/$r/$i.yaml
        fi
    done
    echo ""
done
