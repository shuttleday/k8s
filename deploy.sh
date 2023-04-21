#!/bin/bash

ACCESS_TOKEN=$1
NEW_DOCKERTAG=$2

MANIFEST_FILE="manifests/shuttleday-api.yaml"
CURR_DOCKERTAG=$(awk '/image: ghcr.io\/shuttleday\/api/' $MANIFEST_FILE)

# Pull latest changes
git checkout main
git pull

# End script if the current tag is the same as the supplied tag
if [[ "$CURR_DOCKERTAG" == *"$NEW_DOCKERTAG"* ]]; then
  echo "Tag did not change. Ending script."
  exit 0
fi

# Update manifest otherwise
sed -i "s+ghcr.io/shuttleday/api.*+ghcr.io/shuttleday/api:$NEW_DOCKERTAG+g" $MANIFEST_FILE
git add .
git commit -m "cicd: update manifest to point to shuttleday/api:$NEW_DOCKERTAG"
git push https://$ACCESS_TOKEN@github.com/shuttleday/k8s.git
