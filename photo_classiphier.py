import shutil
from os import listdir, mkdir
from os.path import isfile, join

import numpy as np
import tensorflow as tf
import tensorflow_hub as hub
from PIL import Image
from numpy import float64
from sklearn.cluster import KMeans

metric = 'cosine'

model_url = "https://tfhub.dev/tensorflow/efficientnet/lite0/feature-vector/2"

IMAGE_SHAPE = (224, 224)
IMAGE_PATH = './assets/images/Right'

layer = hub.KerasLayer(model_url, input_shape=IMAGE_SHAPE + (3,))
model = tf.keras.Sequential([layer])


def extract(file):
    file = Image.open(file).convert('L').resize(IMAGE_SHAPE)
    # display(file)

    file = np.stack((file,) * 3, axis=-1)

    file = np.array(file) / 255.0

    embedding = model.predict(file[np.newaxis, ...])
    # print(embedding)
    vgg16_feature_np = np.array(embedding)
    flattended_feature = vgg16_feature_np.flatten()

    # print(len(flattended_feature))
    # print(flattended_feature)
    # print('-----------')
    return flattended_feature


def extract_all_images():
    images = [f for f in listdir(IMAGE_PATH) if isfile(join(IMAGE_PATH, f))]
    with open('vertex.txt', 'w') as f:
        for v, image in zip(map(lambda i: extract(join(IMAGE_PATH, i)), images), images):
            f.write(image)
            f.write(',')
            for xi in v:
                f.write(str(xi))
                f.write(',')
            f.write('\n')


def load_vertex():
    with open('vertex.txt', 'r') as f:
        return list(map(map_vectors, f.readlines()))


def map_vectors(s):
    vector_with_head = s.split(',')[:-1]
    return vector_with_head[0], np.array(vector_with_head[1:], dtype=float64)


labeled_vectors = load_vertex()

labels = list(map(lambda p: p[0], labeled_vectors))
vectors = list(map(lambda p: p[1], labeled_vectors))

clustering = KMeans(n_clusters=150, ).fit(vectors)

for i in range(150):
    mkdir(f'./assets/clusters/{i}')

i = 0
for l in clustering.labels_:
    shutil.copyfile(join(IMAGE_PATH, labels[i]), f'./assets/clusters/{l}/{labels[i]}')
    i += 1

if __name__ == '__main__':
    v = extract('./assets/images/Right/0a667aab4416afbb06f1c2e501030479.png')
    p = clustering.predict([v])
    print(p)
