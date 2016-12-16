#!/bin/bash

source $(dirname $0)/functions.sh || echo "Failed to source functions"

declare -a ELBS


time for each in $(aws elb --region $(getRegion) describe-load-balancers --output text --query LoadBalancerDescriptions[].DNSName); do
STACKNAME=$(getStackName)
  if [[ "$(echo $each | grep -i "internal-${STACKNAME}" > /dev/null; echo $?)" == "0" ]]; then
    ELBS+=( "$each" )
  fi
done

if [[ "${#ELBS[*]}" -eq "0" ]]; then #If number of records is 0 fail visibly
  errorAndExit "Failed to find any ELB records for stack named ${STACKNAME}" 1
else
  info "Number of records ${#ELBS[*]}: ${ELBS[*]}"
fi
