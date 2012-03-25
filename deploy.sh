#!/usr/bin/env bash

if [[ $# -ne 3 ]]; then
	echo "Usage: deploy.sh NAME ENVIRONMENT COMMAND"
  
else
  echo "Usage: deploy.sh NAME ENVIRONMENT COMMAND"
  echo "Usage: deploy.sh $1 $2 $3"
  
  name=$1 cap $2 $3
  
fi
