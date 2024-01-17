#!/bin/bash

NAMES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "web")
IMAGE_ID=ami-0d4949a5a5686445c
SECURITY_GROUP_ID=sg-0d09274b7b3d19419
#DOMAIN_NAME=joindevops.online
#HOSTED_ZONE_ID=Z0308214GYCUYHGJHT8R

# Improvement: Use a function to create an EC2 instance
create_ec2_instance() {
    local INSTANCE_TYPE=""
    local SERVICE_NAME=$1

    # Set instance type based on service name
    if [[ $SERVICE_NAME == "mongodb" || $SERVICE_NAME == "mysql" ]]; then
        INSTANCE_TYPE="t3.medium"
    else
        INSTANCE_TYPE="t2.micro"
    fi

    echo "Creating $SERVICE_NAME instance"
    local IP_ADDRESS=$(aws ec2 run-instances --image-id $IMAGE_ID \
                        --instance-type $INSTANCE_TYPE \
                        --security-group-ids $SECURITY_GROUP_ID \
                        --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$SERVICE_NAME}]" \
                        | jq -r '.Instances[0].PrivateIpAddress')
    
    echo "Created $SERVICE_NAME instance: $IP_ADDRESS"
}

# Loop through service names and create EC2 instances
for SERVICE_NAME in "${NAMES[@]}"; do
    create_ec2_instance $SERVICE_NAME
done
