cd ../../data_marts/customer_data/
python generate_mongo_data.py
cd ../../local_version
sh init.sh
python data_preparation.py

