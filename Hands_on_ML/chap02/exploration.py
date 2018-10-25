#!/usr/bin/env python3

from load_data import *

def main():
	fetch_housing_data()
	housing = load_housing_data()

	print(housing.head())
	print(housing.info())
	print(housing.describe())
	print(housing['ocean_proximity'].value_counts())

	housing.hist(bins=50, figsize=(20,15))

	housing['income_cat'] = np.ceil(housing['median_income'] / 1.5)
	housing['income_cat'].where(housing['income_cat'] < 5, 5.0, inplace=True)
	strat_train_set, strat_test_set = split(housing)
	for set_ in(strat_train_set, strat_test_set): 
		set_.drop('income_cat', axis=1, inplace=True)

	housing = strat_train_set.copy()	
	housing.plot(kind='scatter', x='longitude', y='latitude', alpha=0.1,
		s=housing['population']/100, label='population', figsize=(10,7),
		c='median_house_value', cmap=plt.get_cmap('jet'), colorbar=True,  
		)
	plt.legend()

	corr_matrix =  housing.corr()
	print(corr_matrix['median_house_value'].sort_values(ascending=False))
	attributes = ['median_house_value', 'median_income', 'total_rooms', 
				  'housing_median_age']
	scatter_matrix(housing[attributes], figsize=(12, 8))			  
	housing.plot(kind='scatter', x='median_income', y='median_house_value')
	plt.show()

	transform(housing)
	corr_matrix_new = housing.corr()
	print(corr_matrix_new['median_house_value'].sort_values(ascending=False))

if __name__ == '__main__':
	main()