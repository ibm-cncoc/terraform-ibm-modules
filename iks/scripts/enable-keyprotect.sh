#!/usr/bin/env bash
echo "Cluster:${CLUSTER}"
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

# This will create a root key with name root key
# Add payload to have BYOK
# Otherwise, root key will be created for you
echo "Getting ROOT KEY from supplied key protect instance.........."
ROOT_KEY=$(curl -X GET \
  https://${REGION}.kms.cloud.ibm.com/api/v2/keys \
  -H "authorization: Bearer ${IAM_TOKEN}" \
  -H 'accept: application/vnd.ibm.collection+json' \
  -H "bluemix-instance: ${PARSED_KEYPROTECT_ID}" \
    | jq -r .'resources[0].id' )


echo "ROOTKEY with ID: ${ROOT_KEY} associated with Key Protect instance ID: ${PARSED_KEYPROTECT_ID} will be used for encryption"

# Login to ibmcloud account using apikey and target right resource group and region
ibmcloud login --apikey ${APIKEY} -g ${RESOURCE_GROUP} -r ${REGION}

# Enable Key Protect on cluster using root key retrieved above
ibmcloud ks key-protect-enable --cluster $CLUSTER --key-protect-url $REGION.kms.cloud.ibm.com --key-protect-instance ${PARSED_KEYPROTECT_ID} --crk $ROOT_KEY