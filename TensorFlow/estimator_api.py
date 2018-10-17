#!/usr/bin/env python3

import tensorflow as tf 

"""
tf.estimator.LinearRegressor
tf.estimator.DNNRegressor
tf.estimator.DNNLinearCombinedRegressor

tf.estimator.LinearClassifier
tf.estimator.DNNClassifier
tf.estimator.DNNLinearCombinedClassifier
"""

def train_input_fn():
	features = {'sq_footage': [1000, 2000, 3000, 1000],
	'type': ['house', 'house', 'house', 'apt']}
	labels = [500, 1000, 1500, 700]
	return features, labels

def predict_input_fn():
	features = {'sq_footage': [1500, 1800],
	'type': ['house', 'apt']}
	return features

def main():
	featcols = [tf.feature_column.numeric_column('sq_footage'),
	        tf.feature_column.categorical_column_with_vocabulary_list('type', ['house', 'apt'])]	
	model = tf.estimator.LinearRegressor(featcols)#, './model_trained')

	model.train(train_input_fn, steps=100)
	predictions = model.predict(predict_input_fn)
	print(next(predictions))
	print(next(predictions))	

if __name__ == '__main__':
	main()