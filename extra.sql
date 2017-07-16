/* create db cronos_owner */
-- USER cronos_owner WITH LOGIN PASSWORD 'XXX' ;
/* create db user */
-- CREATE USER cronos WITH LOGIN PASSWORD 'XXX'



⇒ create a sql script
pg_dump cronos_db > cronos_db.sql
⇒ create a compressed dump file
pg_dump -Fc -f cronos_db.dump cronos_db

⇒ restore a database from its backup sql script
psql -d mydb -f cronos_db.sql
⇒ restore a database from its compressed backup file
pg_restore -C -d postgres cronos_db.dump    