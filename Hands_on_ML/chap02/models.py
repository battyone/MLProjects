#!/usr/bin/env python3

from prepare_data import *
from sklearn.linear_model import LinearRegression

def main():

	housing = load_housing_data()	
	X_train, y_train = get_ml_ready_data()

	lin_reg = LinearRegression()
	lin_reg.fit(X_train, y_train)
	
	print(y_train[1:9])
	print(lin_reg.predict(X_train)[0:10])

if __name__ == '__main__':
	main()	