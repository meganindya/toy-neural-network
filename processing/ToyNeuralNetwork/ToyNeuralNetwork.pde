NeuralNetwork network;
final int
    hspace = 100,
    vspace = 25,
    buffer = 25,
    radius = 10,
    networkWidth, networkHeight;

void setup() {
    int layers[] = new int[] { 24, 8, 8, 4 };

    int layersCount = layers.length;
    int maxLayerCount = 0;
    for (int i = 0; i < layersCount; i++) {
        maxLayerCount = max(maxLayerCount, layers[i]);
    }

    networkWidth = hspace * (layersCount - 1),
    networkHeight = vspace * (maxLayerCount - 1);

    size(buffer * 2 + networkWidth, buffer * 2 + networkHeight);

    background(255);
    frameRate(2);

    network = new NeuralNetwork(layers);
}

void draw() {
    network.show(buffer, buffer + networkHeight / 2, hspace, vspace, radius);
}
