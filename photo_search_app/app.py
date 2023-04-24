import base64
from io import BytesIO
from types import SimpleNamespace

import numpy as np
import tensorflow as tf
import tensorflow_hub as hub
from PIL import Image
from flask import Flask, jsonify, json, request, redirect
from flask_cors import CORS
from numpy import float64
from sklearn.cluster import KMeans

N_CLUSTERS = 150

app = Flask(__name__)
cors = CORS(app, resources={r"*": {"origins": "*"}})

metric = 'cosine'

model_url = "https://tfhub.dev/tensorflow/efficientnet/lite0/feature-vector/2"

IMAGE_SHAPE = (224, 224)
IMAGE_PATH = './assets/images/Right'

layer = hub.KerasLayer(model_url, input_shape=IMAGE_SHAPE + (3,))
model = tf.keras.Sequential([layer])


def extract(img):
    file = img.convert('L').resize(IMAGE_SHAPE)
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


def load_vertex():
    with open('vertex4.txt', 'r') as f:
        return list(map(map_vectors, f.readlines()))


def map_vectors(s):
    vector_with_head = s.split(',')[:-1]
    return vector_with_head[0], np.array(vector_with_head[1:], dtype=float64)


labeled_vectors = load_vertex()

labels = list(map(lambda p: p[0], labeled_vectors))
vectors = list(map(lambda p: p[1], labeled_vectors))

clustering = KMeans(n_clusters=N_CLUSTERS, ).fit(vectors)
i = 0

labels_groups = [[] for _ in range(N_CLUSTERS)]
for l in clustering.labels_:
    labels_groups[l].append(labels[i])
    i += 1


@app.route('/')
def get_app():
    return redirect('static/index.html', 301)


@app.route('/static/#/')
def get_app_alt():
    return redirect('/static/index.html', 301)


@app.route('/static/')
def get_app_short():
    return redirect('/static/index.html', 301)


@app.route('/pictures')
def get_pictures():
    return jsonify({'pictures': labels})


@app.route('/pictures/groups')
def get_pictures_groups():
    return jsonify({'groups': labels_groups})


@app.route('/pictures/:picture_id')
def get_picture(picture_id):
    return 'Hello World!'


@app.route('/pictures/predict', methods=['POST'])
def post_picture_predict():
    picture = json.loads(request.data, object_hook=lambda d: SimpleNamespace(**d))
    im_bytes = base64.b64decode(picture.base64)
    im_file = BytesIO(im_bytes)
    img = Image.open(im_file)
    v = extract(img)
    p = clustering.predict([v])
    print(p)

    return jsonify({'pictures': labels_groups[p[0]]})


def run_app():
    return app


if __name__ == '__main__':
    app.run()
