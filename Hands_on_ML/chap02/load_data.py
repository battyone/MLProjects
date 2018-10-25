#!/usr/bin/env python3

import os
import tarfile
from six.moves import urllib
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import hashlib
from sklearn.model_selection import StratifiedShuffleSplit
from pandas.plotting import scatter_matrix

DOWNLOAD_ROOT = 'https://raw.githubusercontent.com/ageron/handson-ml/master/'
HOUSING_PATH = os.path.join('datasets', 'housing')
HOUSING_URL = DOWNLOAD_ROOT + 'datasets/housing/housing.tgz'

def fetch_housing_data(housing_url=HOUSING_URL, housing_path=HOUSING_PATH):
	if not os.path.isdir(housing_path):
		os.makedirs(housing_path)
	tgz_path = os.path.join(housing_path, 'housing.tgz')	
	urllib.request.urlretrieve(housing_url, tgz_path)
	housing_tgz = tarfile.open(tgz_path)
	housing_tgz.extractall(path=HOUSING_PATH)
	housing_tgz.close()

def load_housing_data(housing_path=HOUSING_PATH):
	csv_path = os.path.join(housing_path, 'housing.csv')
	return pd.read_csv(csv_path)

def	split(housing):
	split = StratifiedShuffleSplit(n_splits=1, test_size=0.2, random_state=42)
	for train_idx, test_idx in split.split(housing, housing['income_cat']):
		strat_train_set = housing.loc[train_idx]
		strat_test_set = housing.loc[test_idx]
	return strat_train_set, strat_test_set

def transform(housing):
	housing['rooms_per_household'] = housing['total_rooms']/housing['households']
	housing['bedrooms_per_rooms'] = housing['total_bedrooms']/housing['total_rooms']
	housing['population_per_household'] = housing['population']/housing['households']
	return housing

def main():
	pass

if __name__ == '__main__':
	main()	