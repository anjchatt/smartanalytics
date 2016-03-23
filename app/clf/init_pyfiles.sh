jupyter nbconvert --to python __init__.ipynb
cd ../../local_version
jupyter nbconvert --to python data_ingestion.ipynb 
jupyter nbconvert --to python data_preparation.ipynb
cd ../data_marts/customer_data
jupyter nbconvert --to python generate_mongo_data.ipynb
cd ../customer_matching
jupyter nbconvert --to python a01_init_database.ipynb


