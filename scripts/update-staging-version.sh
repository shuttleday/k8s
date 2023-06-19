#!/bin/bash

# Store the input tag value in a variable
input_tag=$1

# Read the current tag value from overlays/staging/api-deployment.patch.yml
current_tag=$(awk -F'ghcr.io/shuttleday/api:' '/ghcr.io\/shuttleday\/api/ {match($2, /[0-9]+\.[0-9]+\.[0-9]+-rc([0-9]+)/, arr); print substr($2, RSTART, RLENGTH), arr[1]}' ../overlays/staging/api-deployment.patch.yml)

# Extract semantic version of the tag
current_semantic_version=$(echo "${current_tag}" | awk -F'-rc' '{print $1}')

# Extract the numeric portion of "rc"
current_rc_number=$(echo "${current_tag}" | awk -F'-rc' '{print $2}')

# Check if the input tag is different from the current tag
if [[ "${input_tag}" != "${current_semantic_version}" ]]; then
  # Perform the substitution using sed
  sed -i "s+ghcr.io/shuttleday/api.*+ghcr.io/shuttleday/api:${input_tag}-rc1+g" ../overlays/staging/api-deployment.patch.yml
  sed -i "s+ghcr.io/shuttleday/frontend.*+ghcr.io/shuttleday/frontend:${input_tag}-rc1+g" ../overlays/staging/frontend-deployment.patch.yaml
else
  # Increment the "rc" number
  updated_rc_number=$((current_rc_number + 1))
  
  # Construct the updated tag with the incremented "rc" number
  updated_tag="${input_tag}-rc${updated_rc_number}"

  # Perform substitution using sed with the updated_tag
  sed -i "s+ghcr.io/shuttleday/api.*+ghcr.io/shuttleday/api:${updated_tag}+g" ../overlays/staging/api-deployment.patch.yml
  sed -i "s+ghcr.io/shuttleday/frontend.*+ghcr.io/shuttleday/frontend:${updated_tag}+g" ../overlays/staging/frontend-deployment.patch.yaml
  
  echo "The input tag is the same as the current tag. Incremented release candidate (rc) number: ${updated_tag}"
fi
