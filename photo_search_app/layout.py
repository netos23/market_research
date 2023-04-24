from os import listdir
from os.path import isfile, join

import numpy as np
import tensorflow as tf
import tensorflow_hub as hub
from PIL import Image

metric = 'cosine'

model_url = "https://tfhub.dev/tensorflow/efficientnet/lite0/feature-vector/2"

IMAGE_SHAPE = (224, 224)
IMAGE_PATH = './static/Right'

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
    return flattended_feature / np.linalg.norm(flattended_feature)


def extract_all_images():
    images = [f for f in listdir(IMAGE_PATH) if isfile(join(IMAGE_PATH, f))]
    with open('vertex_norm.txt', 'w') as f:
        for v, image in zip(map(lambda i: extract(join(IMAGE_PATH, i)), images), images):
            f.write(image)
            f.write(',')
            for xi in v:
                f.write(str(xi))
                f.write(',')
            f.write('\n')


extract_all_images()
