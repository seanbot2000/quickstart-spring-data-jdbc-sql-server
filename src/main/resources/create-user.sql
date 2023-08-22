cat << EOF > create_user.sql
USE demo;
GO
CREATE USER snoyes WITH PASSWORD='Hamwich01!'
GO
GRANT CONTROL ON DATABASE::smart-cache TO <snoyes>;
GO
EOF