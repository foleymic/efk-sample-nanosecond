#!/bin/bash

function getLocalIP()
{
  hostname=$1
  echo `ping ${pingIPv4} ${pingcount} ${hostname} | grep -Eo -m 1 '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}';`
}

export ENABLE_SUB_SECOND_PRECISION=false
export LOCALHOST=$(getLocalIP $(HOSTNAME))

echo "Deploying the EFK stack!"
docker-compose -f docker-compose.yml up -d 
echo


# Wait for Elastic to start up before doing anything.
echo "Waiting for Elastic to be ready!"
until $(curl --output /dev/null --silent --head --fail http://localhost:9200); do
    printf '.'
    sleep 5
done

echo
echo "Almost there..."
echo "Need to wait on Kibana too."
sleep 30

echo


# curl -X PUT "http://localhost:9200/_template/fluent*/" \
# -H 'kbn-xsrf: true' \
# -H 'Content-Type: application/json' \
# -d'
# {
#   "index_patterns": [
#     "fluent-*"
#   ],
#   "settings": {
#     "index.number_of_shards": 3,
#     "index.number_of_replicas": 0
#   },
#   "mappings": {
#     "properties": {
#       "@timestamp": {
#         "type": "date_nanos"
#       }
#     },
#     "dynamic_templates": [
#       {
#         "strings_as_text": {
#           "match_mapping_type": "string",
#           "mapping": {
#             "type": "text"
#           }
#         }
#       }
#     ]
#   }
# }
# '

# Import the index pattern
curl -X POST "http://${LOCALHOST}:5601/api/saved_objects/index-pattern/fluent" \
-H 'kbn-xsrf: true' \
-H 'Content-Type: application/json' \
-d'
{
  "attributes": {
    "title" : "fluent-*",
    "timeFieldName" : "@timestamp"
  }
}
'

# Set the default index pattern in kibana
curl -X POST "http://${LOCALHOST}:5601/api/kibana/settings" \
-H 'kbn-xsrf: true' \
-H 'Content-Type: application/json' \
-d'
{
    "changes":{
      "defaultIndex" : "fluent"
    }
}
'

echo
echo "Elastic is up!"
echo "Starting the gen stack to begin pumping in data."
docker-compose -f generator.yml up -d 