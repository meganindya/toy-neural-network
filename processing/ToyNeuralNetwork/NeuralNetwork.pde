class NeuralNetwork {
    private Matrix X, Y;
    private Matrix W[];
    private float b[];
    private Dimensions dims[];
    private int layers[], nLayers;

    NeuralNetwork(Matrix X, Matrix Y, int layers[]) {
        this.X = X;
        this.Y = Y;
        this.layers = layers;

        nLayers = layers.length - 1;

        W = new Matrix[nLayers + 1];
        for (int i = 1; i <= nLayers; i++) {
            W[i] = new Matrix(layers[i], layers[i - 1]);
        }
        randomInitialize();

        b = new float[nLayers + 1];
    }

    private void randomInitialize() {
        W[0] = null;
        for (int i = 1; i < W.length; i++) {
            Matrix w = W[i];
            Dimensions dims = w.getDims();

            for (int r = 0; r < dims.rows; r++) {
                for (int c = 0; c < dims.cols; c++) {
                    w.setCell(r, c, random(-1, 1));
                }
            }
        }
    }

    /*void show(int w, int h) {
        int max = 0;
        for (int i = 0; i < nLayers; i++) {
            if (layers[i] > max) {
                max = nLayers[i];
            }
        }
        int r = 10, vspace = 25, hspace = 100;

        stroke(0);
        fill(127);
        push();

        translate(50, h / 2);

        ellipseMode(CENTER);
        for (int i = 0; i < nLayers - 1; i++) {
            int x = i * hspace;
            for (int m = 0; m < layers[i]; m++) {
                int yM = (m - layers[i] / 2) * vspace;
                if (layers[i] % 2 == 0)
                    yM += vspace / 2;
                for (int n = 0; n < layers[i + 1]; n++) {
                    int yN = (n - layers[i + 1] / 2) * vspace;
                    if (layers[i + 1] % 2 == 0)
                        yN += vspace / 2;
                    line(x, yM, x + hspace, yN);
                }
                ellipse(x, yM, r * 2, r * 2);
            }
        }
        for (int i = 0; i < layers[nLayers - 1]; i++) {
            int y = (i - layers[nLayers - 1] / 2) * vspace;
            if (layers[nLayers - 1] % 2 == 0)
                y += vspace / 2;
            ellipse((nLayers - 1) * hspace, y, r * 2, r * 2);
        }

        pop();
    }*/
}
