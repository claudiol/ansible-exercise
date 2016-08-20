#!/bin/sh

if [ "$1" == "" ]; then
    echo "Please pass in a YAML file to check."
    exit
fi

PYTHONINSTALLED=`which python`

if [ $? == 0 ]; then
  python -c 'import yaml, sys; print yaml.load(sys.stdin)' < $1
else
  echo "Have you installed Python?"
  echo "You will need to install the standard Python packages as well as"
  echo "the PyYAML package."
  exit
fi
