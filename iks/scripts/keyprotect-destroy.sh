#!/usr/bin/env bash
echo "Region:${REGION}"
echo "KEYPROTECT INSTANCE:${KEYPROTECT}"

PARSED_KEYPROTECT_ID=$(echo $KEYPROTECT | awk -F ':' '{print $8}')
echo "PARSED KEYPROTECT ID:${PARSED_KEYPROTECT_ID}"
echo 'Create IAM Token with API Key'

# NOTE: THIS NEEDS API KEY
IAM_TOKEN=$(curl -X POST \
  "https://iam.ng.bluemix.net/oidc/token?grant_type=urn:ibm:params:oauth:grant-type:apikey&apikey=${APIKEY}" \
  -H "Accept: application/json" \
  -H "Content-Type: application/x-www-form-urlencoded" | jq -r '.access_token')

IFS=$'\n'

# Get all Keys
KEYS=( `curl -s -X GET \
  https://${REGION}.kms.cloud.ibm.com/api/v2/keys \
  -H "authorization: Bearer ${IAM_TOKEN}" \
  -H "bluemix-instance: ${PARSED_KEYPROTECT_ID}" \
  -H "accept: application/vnd.ibm.collection+json" | jq -c '.resources' | jq -c '.[]'` )
echo "*******  DELETING ALL  ROOT KEYS inside the KP instance  ********"
echo "If any clusters are encrypted using these root keys. It may cause troubles and this op cannot be undone"
# Delete all keys from KP Instance
for i in ${!KEYS[*]}; do
	KEY=$(echo "${KEYS[$i]}" | jq -r '.id')
	curl -X DELETE "https://${REGION}.kms.cloud.ibm.com/api/v2/keys/${KEY}" -H "authorization: Bearer ${IAM_TOKEN}" -H "bluemix-instance: ${PARSED_KEYPROTECT_ID}" -H "accept: application/vnd.ibm.kms.key+json"
done
