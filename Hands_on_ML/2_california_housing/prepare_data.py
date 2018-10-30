#!/usr/bin/env python3

from load_data import *
from sklearn.impute import SimpleImputer 
from sklearn.preprocessing import OneHotEncoder
from sklearn.base import BaseEstimator, TransformerMixin
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.pipeline import FeatureUnion

rooms_ix, bedrooms_ix, population_ix, household_ix = 3, 4, 5, 6

class CombinedAttributesAdder(BaseEstimator, TransformerMixin):
	def __init__(self, add_bedrooms_per_room=True):
		self.add_bedrooms_per_room = add_bedrooms_per_room
	def fit(self, X, y=None):
		return self
	def transform(self, X, y=None):
		rooms_per_household = X[:, rooms_ix] / X[:, household_ix]	
		population_per_household = X[:, population_ix] / X[:, household_ix]
		if self.add_bedrooms_per_room:
			add_bedrooms_per_room = X[:, bedrooms_ix] / X[:, rooms_ix]
			return np.c_[X, rooms_per_household, population_per_household,
						 add_bedrooms_per_room]
		else: 
			return np.c_[X, rooms_per_household, population_per_household]				 

class DataFrameSelector(BaseEstimator, TransformerMixin):
	def __init__(self, attribute_names):
		self.attribute_names = attribute_names
	def fit(self, X, y=None):
		return self
	def transform(self, X):
		return X[self.attribute_names].values


def fill_missing_values(housing):
	imputer = SimpleImputer(strategy='median')
	housing_num = housing.drop('ocean_proximity', axis=1)
	imputer.fit(housing_num)
	X = imputer.transform(housing_num)
	housing_tr = pd.DataFrame(X, columns=housing_num.columns)

def one_hot_encoding(housing):
	housing_cat = housing['ocean_proximity']
	cat_encoder = OneHotEncoder()
	housing_cat_reshaped = housing_cat.values.reshape(-1, 1)
	housing_cat_1hot = cat_encoder.fit_transform(housing_cat_reshaped)


def get_ml_ready_data():
	fetch_housing_data()
	housing = load_housing_data()

	housing['income_cat'] = np.ceil(housing['median_income'] / 1.5)
	housing['income_cat'].where(housing['income_cat'] < 5, 5.0, inplace=True)

	housing['rooms_per_household'] = housing['total_rooms']/housing['households']
	housing['bedrooms_per_rooms'] = housing['total_bedrooms']/housing['total_rooms']
	housing['population_per_household'] = housing['population']/housing['households']

	strat_train_set, strat_test_set = split(housing)
	for set_ in(strat_train_set, strat_test_set): 
		set_.drop('income_cat', axis=1, inplace=True)


	housing = strat_train_set.drop('median_house_value', axis=1)
	housing_labels = strat_train_set['median_house_value'].copy()
	housing_num = housing.drop('ocean_proximity', axis=1)

	one_hot_encoding(housing)

	attr_adder = CombinedAttributesAdder(add_bedrooms_per_room=False)
	housing_extra_attribs = attr_adder.transform(housing.values)

	num_attribs = list(housing_num)
	cat_attribs = ['ocean_proximity']

	num_pipeline = Pipeline([
		('selector', DataFrameSelector(num_attribs)), 
		('imputer', SimpleImputer(strategy='median')),
		('std_scalar', StandardScaler()),
		])
	cat_pipeline = Pipeline([
		('selector', DataFrameSelector(cat_attribs)),
		('cat_encoder', OneHotEncoder(sparse=False)),
		])
	full_pipeline = FeatureUnion(transformer_list=[
		('num_pipeline', num_pipeline), 
		('cat_pipeline', cat_pipeline)
		])

	housing_prepared = full_pipeline.fit_transform(housing)
	return housing_prepared, housing_labels

if __name__ == '__main__':
	pass