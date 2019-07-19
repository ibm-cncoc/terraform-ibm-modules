#!/usr/bin/env bash

echo "Region:${REGION}"
echo "KEYPROTECT INSTANCE:${KEYPROTECT}"

PARSED_KEYPROTECT_ID=$(echo $KEYPROTECT | awk -F ':' '{print $8}')
echo "PARSED KEYPROTECT ID:${PARSED_KEYPROTECT_ID}"
echo 'Creating IAM Token with API Key....'
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

# Below function creates the data to be used by POST request for key creation
# This saves you from all sort of headaches concerning shell quoting and is easy to maintain
# Refer to API docs of IBM KP; you can add more fields to the json if you want to
generate_post_key_data()
{
  cat <<EOF
  {
  "metadata": {
    "collectionType": "application/vnd.ibm.kms.key+json",
    "collectionTotal": 1
  },
  "resources": [
    {
    "type": "application/vnd.ibm.kms.key+json",
    "name": "$KEY_NAME",
    "description": "$KEY_DESCRIPTION",
    "extractable": false,
    "payload": "$KEY_PAYLOAD"
    }
  ]
  }
EOF
}

# This will create a root key with name root key
# Add payload to have BYOK
# Otherwise, root key will be created for you
echo "Creating ROOT KEY......"
RESPONSE=$(curl -X POST \
  https://${REGION}.kms.cloud.ibm.com/api/v2/keys \
  -H "authorization: Bearer ${IAM_TOKEN}" \
  -H "bluemix-instance: ${PARSED_KEYPROTECT_ID}" \
  -H 'content-type: application/vnd.ibm.kms.key+json' \
  -d "$(generate_post_key_data)")

echo $RESPONSE
# If Root KEY ID returned is  null, exits
ROOT_KEY=$(echo $RESPONSE | jq -r .'resources[0].id')
if [ $ROOT_KEY = "null" ]; then
  echo "ROOT KEY creation failed"
  echo $RESPONSE
  exit 1
fi

echo "Created ROOTKEY with ID: ${ROOT_KEY}"

