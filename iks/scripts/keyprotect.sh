#!/usr/bin/env bash
echo "Region:${REGION}"
echo "KEYPROTECT INSTANCE:${KEYPROTECT}"

PARSED_KEYPROTECT_ID=$(echo $KEYPROTECT | awk -F ':' '{print $8}')
echo "PARSED KEYPROTECT ID:${PARSED_KEYPROTECT_ID}"
echo 'Create IAM Token with API Key'
# NOTE: THIS NEEDS API KEY
IAM_TOKEN=$(curl -X POST \
  'https://iam.ng.bluemix.net/oidc/token?grant_type=urn:ibm:params:oauth:grant-type:apikey&apikey='"$APIKEY"'' \
  -H 'Accept: application/json' \
  -H 'Content-Type: application/x-www-form-urlencoded' | jq -r '.access_token')

# Below function to create the data to be used by POST request for key creation
# This saves you from all sort of headaches concerning shell quoting and is easy to maintain
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
ROOT_KEY=$(curl -X POST \
  https://${REGION}.kms.cloud.ibm.com/api/v2/keys \
  -H "authorization: Bearer ${IAM_TOKEN}" \
  -H "bluemix-instance: ${PARSED_KEYPROTECT_ID}" \
  -H 'content-type: application/vnd.ibm.kms.key+json' \
  -d "$(generate_post_key_data)" | jq -r .'resources[0].id' )


echo "Created ROOTKEY with ID: ${ROOT_KEY}"

