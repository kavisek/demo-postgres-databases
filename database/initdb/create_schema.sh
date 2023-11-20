set -e
set -u

function create_schema(){
    psql -v ON_ERROR_STOP=1 -d $POSTGRES_DB --username "$POSTGRES_USER" <<-EOSQL
        CREATE SCHEMA IF NOT EXISTS $POSTGRES_SCHEMA;
EOSQL
}

function create_admin_user(){
    psql -v ON_ERROR_STOP=1 -d $POSTGRES_DB --username "$POSTGRES_USER" <<-EOSQL
        CREATE USER admin WITH PASSWORD '$POSTGRES_PASSWORD';
        GRANT ALL PRIVILEGES ON DATABASE $POSTGRES_DB TO admin;
        -- Additional privileges can be granted as needed
EOSQL
}

if [ -n "$POSTGRES_SCHEMA" ]; then
    echo "creating schema $POSTGRES_SCHEMA."
    create_schema
    echo "creating admin user."
    create_admin_user
fi

echo "initdb script completed."