cd ../../data_marts/customer_data/
python2.7 generate_mongo_data.py
cd ../../local_version
sh init.sh
python2.7 data_preparation.py

# generate data for PCI queries
cd ../data_analysis/PCI
python2.7 data_preparation_pci.py

