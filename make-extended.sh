#!/bin/bash

## 
# Initialize arrays for before and after '--'
before=()
after=()

# Flag to start collecting after '--'
collect_after=false

# Loop through all arguments
for arg in "$@"; do
  if [[ "$arg" == "--" ]]; then
    collect_after=true
  elif $collect_after; then
    after+=("$arg")
  else
    before+=("$arg")
  fi
done

before_result=$(make "${before[@]}" -n )
echo "${before_result} ${after[@]}"

if [ ${#after[@]} -gt 0 ]; then
  $before_result "${after[@]}"
else
  # If "after" is empty, just run the "before" result
  $before_result
fi
# # Now, run the command with '-n' added after the first argument
# $before_result "${after[@]}"
