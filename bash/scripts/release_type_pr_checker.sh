#!/bin/sh -l
export GITHUB_TOKEN=$INPUT_GITHUB_TOKEN
if [[ -z $INPUT_PULL_REQUEST_NUMBER ]];
then
    PR_INFO=$(gisce_github get-commits-sha-from-merge-commit --owner $INPUT_OWNER --repository $INPUT_REPOSITORY --sha $INPUT_MERGE_COMMIT)
else
    PR_INFO=$(gisce_github get-pullrequest-info --owner $INPUT_OWNER --repository $INPUT_REPOSITORY --pr $INPUT_PULL_REQUEST_NUMBER)
fi
pr_labels=$( echo $PR_INFO | jq -r '.pullRequest.labels' )
is_minor=false
is_major=false
is_patch=false
for label in echo $( echo $pr_labels | jq -r '.[].name' ); do
  if [[ $label == 'minor' ]]; then
    is_minor=true
  elif [[ $label == 'major' ]]; then
    is_major=true
  elif [[ $label == 'patch' ]]; then
    is_patch=true
  fi
done
VERSION_TYPE=false
if [[ $is_major == true ]]; then
  VERSION_TYPE="major"
elif [[ $is_minor == true ]]; then
  VERSION_TYPE="minor"
elif [[ $is_patch == true ]]; then
  VERSION_TYPE="patch"
fi
echo "release_type=$VERSION_TYPE" >> $GITHUB_OUTPUT
