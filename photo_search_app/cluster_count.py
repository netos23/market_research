import matplotlib.pyplot as plt
import numpy as np
from numpy import float64
from scipy.spatial.distance import cdist
from sklearn.cluster import KMeans


def load_vertex():
    with open('vertex_norm.txt', 'r') as f:
        return list(map(map_vectors, f.readlines()))


def map_vectors(s):
    vector_with_head = s.split(',')[:-1]
    return vector_with_head[0], np.array(vector_with_head[1:], dtype=float64)


labeled_vectors = load_vertex()

labels = list(map(lambda p: p[0], labeled_vectors))
vectors = np.array(list(map(lambda p: p[1], labeled_vectors)))

distortions = []
inertias = []
mapping1 = {}
mapping2 = {}
N = 100
K = range(1, N)

with open('cluster_count_normal.txt', 'w') as f:
    for k in K:
        print(f'progress: {k / N}')
        # Building and fitting the model
        clustering = KMeans(n_clusters=k).fit(vectors)
        clustering.fit(vectors)

        distortion = sum(np.min(cdist(vectors, clustering.cluster_centers_, 'euclidean'), axis=1)) / vectors.shape[0]
        distortions.append(distortion)
        inertias.append(clustering.inertia_)

        mapping1[k] = distortion
        mapping2[k] = clustering.inertia_
        f.write(f"{k}, {distortion}\n")
        f.flush()

plt.plot(K, distortions, 'bx-')
plt.xlabel('Values of K')
plt.ylabel('Distortion')
plt.title('The Elbow Method using Distortion')
plt.show()
