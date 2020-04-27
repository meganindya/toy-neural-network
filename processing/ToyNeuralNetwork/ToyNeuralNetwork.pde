final int
    hspace = 125,
    vspace = 35,
    buffer = 25,
    radius = 15;
int networkWidth, networkHeight;

final int layers[] = new int[] { 16, 8, 8, 4 };
final int layersCount = layers.length;

NeuralNetwork network;
Matrix X, Y;

void initializeSize() {
    int maxLayerCount = 0;
    for (int i = 0; i < layersCount; i++) {
        maxLayerCount = max(maxLayerCount, layers[i]);
    }

    networkWidth = hspace * (layersCount - 1);
    networkHeight = vspace * (maxLayerCount - 1);
}

void settings() {
    initializeSize();
    size(buffer * 2 + networkWidth, buffer * 2 + networkHeight);
}

void setup() {
    frameRate(2);

    network = new NeuralNetwork(layers);
}

void draw() {
    background(255);

    X = new Matrix(layers[0], 1);
    X.randomize(0, 5);
    Y = new Matrix(layers[layersCount - 1], 1);
    Y.setCell(floor(random(0, layers[layersCount - 1])), 0, 1);
    network.train(X, Y, 0.01);

    network.show(buffer, buffer + networkHeight / 2, hspace, vspace, radius);
}
