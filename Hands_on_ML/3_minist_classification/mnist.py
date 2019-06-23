from sklearn.datasets import fetch_mldata

import mnist

train_images = mnist.train_images()
train_labels = minst.train_labels()
test_images = mnist.test_images()
test_labels = mnist.test_labels()

print(len(train_labels))