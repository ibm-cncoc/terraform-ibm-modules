import requests
import json
import os
import time
import sys,argparse
from datetime import datetime


parser=argparse.ArgumentParser()

parser.add_argument('--apikey', help='IBM Cloud API Key',required=True)
parser.add_argument('--rgid', help='Resource group ID',required=True)
parser.add_argument('--region', help='Region of cluster',required=True)
parser.add_argument('--cluster', help='name of the cluster',required=True)


# Read supplied arguments
args    =   parser.parse_args()

api_key             =   args.apikey
resource_group_id   =   args.rgid
region              =   args.region
cluster             =   args.cluster


################# Get IAM token ################

def get_token(api_key):
    get_token_url   =   'https://iam.cloud.ibm.com/identity/token'
    headers         =   { "Accept" : "application/json" , "Content-Type" : "application/x-www-form-urlencoded"}
    params          =   { "grant_type" :   'urn:ibm:params:oauth:grant-type:apikey',
                            "apikey" : api_key}
    r1              =   requests.post(get_token_url,headers=headers,params=params)
    token   =   r1.json()['access_token']
    return token
###################################################

token = get_token(api_key)
 
get_cluster_url = 'https://containers.bluemix.net/v1/clusters/'+cluster
headers={   "Authorization":"Bearer "+token , 
            "X-Region": region,
            #"Account":account,
            "X-Auth-Resource-Group": resource_group_id,

}

count=0
print("******************  Monitoring status **********************")
loop_startTime = time.time()
masterStatusModifiedTime = 0
cluster_created_date = 0
timeout = time.time() + 60*60
status_old  = ""
ready_flag    =   0
while(time.time() < timeout):
    r=requests.get(get_cluster_url , headers=headers)
    #print("Returned Status Code: ",r.status_code)
    if r.status_code   ==  200:
        data    =   r.json()
        #status_new  = data['masterStatus']
        if(status_old   !=  data['masterStatus']):
         print(datetime.utcnow().strftime("%d-%b-%Y (%H:%M:%S.%f)")+ " -> Master Status of the Cluster - ",data['masterStatus'])
        status_old = data['masterStatus']
        if(data['masterStatus']=='Ready'):
            cluster_created_date = data['createdDate']
            masterStatusModifiedTime = data['masterStatusModifiedDate']
            ready_flag  =   1
            break
    elif r.status_code ==  404:
        print("Status Code: ",r.status_code)
        print("Reason: ",r.reason)
        break
    elif r.status_code ==  401:
        print("Status Code: ",r.status_code)
        print("Reason: ",r.reason)
        token = get_token(api_key)
        headers =    {"Authorization":"Bearer "+token , 
            "X-Region": region,
            # "Account":account,
            "X-Auth-Resource-Group": resource_group_id,
        }
        continue

    else:
        print("Status Code: ",r.status_code)
        print("Get Cluster Info API call failed. Reason: ",r.reason)
if(ready_flag==1):
    print("LOOP ENDED")
if(ready_flag==0):
    print("LOOP TIMED OUT - Cluster Master Status did not reach 'Ready' State in 1 hr after kps is enabled")
print("Latest Master Status polled - ", status_old)
loop_endTime = time.time()
elapsedTime = (loop_endTime - loop_startTime) 
print("Elapsed Time (seconds) = %s" % elapsedTime)
print("Master Status Modified Time: ", masterStatusModifiedTime)
