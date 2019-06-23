import numpy as np 
from sklearn import datasets
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler 
from sklearn.svm import LinearSVC

def main():
	iris = datasets.load_iris()
	X = iris['data'][:, (2, 3)]
	y = (iris['target']==2).astype(np.float64)

	svm_clf = Pipeline([
		('scaler', StandardScaler()), 
		('linear_svc', LinearSVC(C=1, loss='hinge')),
		])

	svm_clf.fit(X, y)

	print(svm_clf.predict([[4, 1.7]]))

if __name__ == '__main__':
	main()