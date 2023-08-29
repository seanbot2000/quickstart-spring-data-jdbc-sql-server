# Sample project for Spring Data JDBC with Azure SQL Database, Azure Cache for Redis Enterprise AND Redis Smart Cache

This sample project is used in the [Use Spring Data JDBC with Azure SQL Database](https://docs.microsoft.com/azure/developer/java/spring-framework/configure-spring-data-jdbc-with-azure-sql-server/?WT.mc_id=github-microsoftsamples-judubois) Microsoft documentation quickstart.
It has been modified to additionally stand up a Redis Enterprise Cluster which will be synced with the database using Redis Smart Cache

## Creating the infrastructure

We recommend you create an *env.sh* file to create the following environment variables:

```bash
#!/bin/sh

echo "Setting env variables"

export AZ_RESOURCE_GROUP=<unique-resource group name>
export AZ_DATABASE_NAME=<db name>
export AZ_REDIS_NAME=<cluster name>
export AZ_REDIS_SKU=<Enterprise SKU>
export AZ_LOCATION=<region>
export AZ_REDIS_URL=$AZ_REDIS_NAME.$AZ_LOCATION.redisenterprise.cache.azure.net
export AZ_REDIS_PORT=<port>
export AZ_SQL_SERVER_USERNAME=<username>
export AZ_SQL_SERVER_PASSWORD=XXXXXXXXXXXXXXXXXXX
export AZ_LOCAL_IP_ADDRESS=$(curl http://whatismyip.akamai.com/)
export SPRING_DATASOURCE_CLASS=com.microsoft.sqlserver.jdbc.SQLServerDriver

export SPRING_DATASOURCE_URL="jdbc:sqlserver://$AZ_DATABASE_NAME.database.windows.net:1433;database=$AZ_DATABASE_NAME;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;"
export SPRING_DATASOURCE_USERNAME=$AZ_SQL_SERVER_USERNAME@$AZ_DATABASE_NAME
export SPRING_DATASOURCE_PASSWORD=$AZ_SQL_SERVER_PASSWORD
export SPRING_SMARTCACHE_URL=jdbc:redis://$AZ_REDIS_URL:$AZ_REDIS_PORT
```

You will need to set up a unique `AZ_DATABASE_NAME` as well as a correctly secured `AZ_SQL_SERVER_PASSWORD`.

Once this file is created:

- Use `apt install jq` to add jq support for retrieving response from az commands
- Use `source env.sh` to set up those environment variables
- Use `./create-spring-data-jdbc-sql-server.sh` to create your infrastructure
- Use `./destroy-spring-data-jdbc-sql-server.sh` to delete your infrastructure

## Running the project

This is a standard Maven project, you can run it from your IDE, or using the provided Maven wrapper:

```bash
./mvnw spring-boot:run
```
