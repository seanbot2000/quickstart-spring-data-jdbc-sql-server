#!/bin/sh

echo "Creating cloud resources..."

echo "-----------------------------------------------------"
echo "Using environment variables:"
echo "AZ_RESOURCE_GROUP=$AZ_RESOURCE_GROUP"
echo "AZ_DATABASE_NAME=$AZ_DATABASE_NAME"
echo "AZ_REDIS_NAME=$AZ_REDIS_NAME"
echo "AZ_REDIS_SKU=$AZ_REDIS_SKU"
echo "AZ_LOCATION=$AZ_LOCATION"
echo "AZ_SQL_SERVER_USERNAME=$AZ_SQL_SERVER_USERNAME"
echo "AZ_SQL_SERVER_PASSWORD=$AZ_SQL_SERVER_PASSWORD"
echo "AZ_LOCAL_IP_ADDRESS=$AZ_LOCAL_IP_ADDRESS"

echo "-----------------------------------------------------"
echo "Creating resource group"

az group create \
    --name $AZ_RESOURCE_GROUP \
    --location $AZ_LOCATION \
    -o tsv

echo "-----------------------------------------------------"
echo "Creating SQL Server Server instance"

az sql server create \
    --resource-group $AZ_RESOURCE_GROUP \
    --name $AZ_DATABASE_NAME \
    --location $AZ_LOCATION \
    --admin-user $AZ_SQL_SERVER_USERNAME \
    --admin-password $AZ_SQL_SERVER_PASSWORD \
    -o tsv

echo "-----------------------------------------------------"
echo "Configuring SQL Server Server firewall"
echo "Allowing local IP address: $AZ_LOCAL_IP_ADDRESS"

az sql server firewall-rule create \
    --resource-group $AZ_RESOURCE_GROUP \
    --name $AZ_DATABASE_NAME-database-allow-local-ip \
    --server $AZ_DATABASE_NAME \
    --start-ip-address $AZ_LOCAL_IP_ADDRESS \
    --end-ip-address $AZ_LOCAL_IP_ADDRESS \
    -o tsv

echo "-----------------------------------------------------"
echo "Configuring SQL Server Server database"

az sql db create \
    --resource-group $AZ_RESOURCE_GROUP \
    --name demo \
    --server $AZ_DATABASE_NAME \
    -o tsv

echo "-----------------------------------------------------"
echo "Configuring Redis Cluster"

az redisenterprise create \
    --cluster-name $AZ_REDIS_NAME  \
    --resource-group $AZ_RESOURCE_GROUP \
    --sku $AZ_REDIS_SKU \
    --capacity 2 \
    --client-protocol Plaintext \
    --clustering-policy EnterpriseCluster \
    --location eastus \
    -o tsv

AZ_REDIS_PASSWORD=`az redisenterprise database list-keys --resource-group $AZ_RESOURCE_GROUP --cluster-name $AZ_REDIS_NAME | jq '.primaryKey' --raw-output`

echo "-----------------------------------------------------"
echo "Resources:"
echo "AZ_RESOURCE_GROUP=$AZ_RESOURCE_GROUP"
echo "AZ_DATABASE_NAME=$AZ_DATABASE_NAME"
echo "AZ_REDIS_NAME=$AZ_REDIS_NAME"
echo "AZ_REDIS_SKU=$AZ_REDIS_SKU"
echo "AZ_LOCATION=$AZ_LOCATION"
echo "AZ_SQL_SERVER_USERNAME=$AZ_SQL_SERVER_USERNAME"
echo "AZ_SQL_SERVER_PASSWORD=$AZ_SQL_SERVER_PASSWORD"
echo "AZ_LOCAL_IP_ADDRESS=$AZ_LOCAL_IP_ADDRESS"
echo "AZ_REDIS_PASSWORD=$AZ_REDIS_PASSWORD"

echo "Run: export AZ_REDIS_PASSWORD=$AZ_REDIS_PASSWORD from the shell to propogate for the application"
echo "-----------------------------------------------------"

