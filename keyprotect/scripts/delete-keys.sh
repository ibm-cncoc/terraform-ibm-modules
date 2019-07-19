#!/usr/bin/env bash
echo "Region:${REGION}"
echo "KEYPROTECT INSTANCE:${KEYPROTECT}"
echo "DELETE KEYS FLAG:${DELETE_KEYS}"

PARSED_KEYPROTECT_ID=$(echo $KEYPROTECT | awk -F ':' '{print $8}')
echo "PARSED KEYPROTECT ID:${PARSED_KEYPROTECT_ID}"
echo 'Create IAM Token with API Key'

# NOTE: THIS NEEDS API KEY
RESPONSE=$(curl -X POST \
  'https://iam.ng.bluemix.net/oidc/token?grant_type=urn:ibm:params:oauth:grant-type:apikey&apikey='"$APIKEY"'' \
  -H 'Accept: application/json' \
  -H 'Content-Type: application/x-www-form-urlencoded')
IAM_TOKEN=$(echo $RESPONSE | jq -r '.access_token')

# If IAM token returned is  null, exits
if [ $IAM_TOKEN = "null" ]; then
  echo "Failed to get IAM token"
  echo $RESPONSE
  exit 1
fi
IFS=$'\n'

# Get all Keys
# KEYS=( `curl -s -X GET \
#   https://${REGION}.kms.cloud.ibm.com/api/v2/keys \
#   -H "authorization: Bearer ${IAM_TOKEN}" \
#   -H "bluemix-instance: ${PARSED_KEYPROTECT_ID}" \
#   -H "accept: application/vnd.ibm.collection+json" | jq -c '.resources' | jq -c '.[]'` )

RESPONSE=(`curl -s -X GET \
  https://${REGION}.kms.cloud.ibm.com/api/v2/keys \
  -H "authorization: Bearer ${IAM_TOKEN}" \
  -H "bluemix-instance: ${PARSED_KEYPROTECT_ID}" \
  -H "accept: application/vnd.ibm.collection+json"`)
echo "RESPONSE: ${RESPONSE}"


RESOURCES=$(echo $RESPONSE | jq -c '.metadata.collectionTotal' ) # Get total num of resources in KP instance

echo "Number of resources in KP instance: ${RESOURCES}" # Print num of returned resources from KP instance

# If there are no keys returned
if [ $RESOURCES = 0 ]; then
  echo "No resources found......"
  echo "It is possible that no Keys exists in KP instance...TF proceeds to KP destroy"

# If there are any keys in KP
elif [ $RESOURCES -ge 0 ]; then
  KEYS=$(echo $RESPONSE | jq -c '.resources'| jq -c '.[]' )
  echo "Returned keys info: ${KEYS}"
  # Print Info
  echo "Following keys exist in the KP instance that you are trying to destroy: "
    for i in ${!KEYS[*]}; do
      KEY=$(echo "${KEYS[$i]}" | jq -r '.id')
      echo "KEY with ID: ${KEY}"
    done

  # If 'delete_keys' is set to false, exit
  if [ $DELETE_KEYS == 0 ]; then
  echo "TF variable 'delete_keys' is set to **false**....Cannot delete keys..Exiting...."
  echo "Set 'delete_keys=true' in your plan and do a 'terraform destroy' again"
  echo "Please note that doing the above deletes all root keys and then deletes KP instance"
  exit 1
  fi

  # If 'delete_keys' is set to true, delete all keys in instance
  if [ $DELETE_KEYS == 1 ] ; then
    echo "TF variable 'delete_keys' is set to ***true***"
    echo "Deleting the following keys from KP instance ${PARSED_KEYPROTECT_ID}...."
    for i in ${!KEYS[*]}; do
      KEY=$(echo "${KEYS[$i]}" | jq -r '.id')
      echo "Deleteing KEY with ID: ${KEY}......."
      curl -X DELETE "https://${REGION}.kms.cloud.ibm.com/api/v2/keys/${KEY}" -H "authorization: Bearer ${IAM_TOKEN}" -H "bluemix-instance: ${PARSED_KEYPROTECT_ID}" -H "accept: application/vnd.ibm.kms.key+json"
    done
  fi
# If metadata did not return any info on resource 
else
  echo "something has gone wrong with your request. Check Response of API call from the above log"
fi