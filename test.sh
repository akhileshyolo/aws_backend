#!/bin/bash
ApiGatewayEndpoint=$(aws cloudformation describe-stacks --stack-name apiDemo --query Stacks[0].Outputs[0].OutputValue | tr -d '"')
echo $ApiGatewayEndpoint

echo "POST new input to task api"
curl --location --request POST "$ApiGatewayEndpoint/task" \
--header 'Content-Type: application/json' \
--data-raw '{
    "title": "New Task",
    "task": "Scheduled New Task"
}' > output.txt


ID=$(cat output.txt | grep -Po '\b[0-9a-f]{8}\b-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-\b[0-9a-f]{12}\b')
echo "Extract Task for ID=$ID"
curl --location --request GET "$ApiGatewayEndpoint/task?id=$ID"