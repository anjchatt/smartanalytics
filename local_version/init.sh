psql -U postgres -c "create database twitter;"
psql -d twitter -U postgres -f init.sql
jupyter nbconvert data_ingestion.ipynb --to python
