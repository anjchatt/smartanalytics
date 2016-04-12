cd ../../data_marts/customer_data/
python2.7 generate_mongo_data.py
cd ../../local_version
sh init.sh
python2.7 data_preparation.py

