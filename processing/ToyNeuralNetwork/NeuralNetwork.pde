class NeuralNetwork {
    private Matrix X, Y;
    private Matrix[] W, dW, Z, dZ, A, dA;
    private float[] b, db;
    private Dimensions dims[];
    private int layers[], nLayers;
    private String activationFuncs[];
    private Matrix cost;

    NeuralNetwork(Matrix X, Matrix Y, int layers[]) {
        this.X = X;
        this.Y = Y;
        this.layers = layers;

        nLayers = layers.length - 1;

        W = new Matrix[nLayers + 1];
        dW = new Matrix[nLayers + 1];
        Z = new Matrix[nLayers + 1];
        dZ = new Matrix[nLayers + 1];
        A = new Matrix[nLayers + 1];
        dA = new Matrix[nLayers + 1];
        for (int i = 1; i <= nLayers; i++) {
            W[i] = new Matrix(layers[i], layers[i - 1]);
            dW[i] = new Matrix(layers[i], layers[i - 1]);
            Z[i] = new Matrix(layers[i], 1);
            dZ[i] = new Matrix(layers[i], 1);
            A[i] = new Matrix(layers[i], 1);
            dA[i] = new Matrix(layers[i], 1);

            if (i == nLayers) {
                activationFuncs[i] = "sigmoid";
            } else {
                activationFuncs[i] = "relu";
            }
        }
        initialize();

        b = new float[nLayers + 1];
        db = new float[nLayers + 1];

        cost = new Matrix(layers[nLayers], 1);
    }

    private void initialize() {
        W[0] = Z[0] = null;
        A[0] = X.copy();
        dW[0] = dZ[0] = null;
        activationFuncs[0] = "";

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

    float relu(float z) {
        return z > 0 ? z : 0;
    }

    float drelu(float z) {
        return z > 0 ? 1 : 0;
    }

    float sigmoid(float z) {
        return 1 / (1 + exp(-z));
    }

    float dsigmoid(float z) {
        return sigmoid(z) * sigmoid(1 - z);
    }

    Matrix activate(Matrix m, String func) {
        Dimensions dims = m.getDims();
        Matrix res;

        for (int r = 0; r < dims.rows; r++) {
            for (int c = 0; c < dims.cols; c++) {
                if (func.equals("relu")) {
                    res.setCell(r, c, relu(m.getCell(r, c)));
                } else if (func.equals("drelu")) {
                    res.setCell(r, c, drelu(m.getCell(r, c)));
                } else if (func.equals("sigmoid")) {
                    res.setCell(r, c, sigmoid(m.getCell(r, c)));
                } else if (func.equals("dsigmoid")) {
                    res.setCell(r, c, dsigmoid(m.getCell(r, c)));
                }
            }
        }

        return res;
    }

    void forwardPropagate() {
        for (int i = 1; i <= nLayers; i++) {
            Z[i] = add(mul(W[i], A[i - 1]), b[i]);
            A[i] = activate(Z[i], activationFuncs[i]);
        }
    }

    void calculateCost() {
        int m = layers[nLayers];
        Matrix AL = A[nLayers];
        cost = div(
            add(dot(Y, log(AL.T)), dot(sub(1, Y), log(sub(1, AL)).T)),
            -m
        );
    }

    void backPropagate() {
        for (int i = nLayers; i > 0; i--) {
            dZ[i] = mul(dA[i], activate(Z[i], activationFuncs[i]));

            int m = layers[i - 1];
            dW[i] = div(dot(dZ, A[i - 1].T), m);
            db[i] = div(dZ[i].sum(axis), m);
            dA[i - 1] = dot(W[i].T, dZ[i]);
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
