class NeuralNetwork {
    private Matrix X, Y;
    private Matrix[] W, dW, Z, dZ, A, dA;
    private float[] b, db;
    private int layers[], nLayers;
    private String activationFuncs[];
    private Matrix cost;
    private int outputIndex;

    NeuralNetwork(int layers[]) {
        this.layers = layers;
        nLayers = layers.length - 1;

        W = new Matrix[nLayers + 1];
        dW = new Matrix[nLayers + 1];
        Z = new Matrix[nLayers + 1];
        dZ = new Matrix[nLayers + 1];
        A = new Matrix[nLayers + 1];
        dA = new Matrix[nLayers + 1];
        activationFuncs = new String[nLayers + 1];

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

        W[0] = dW[0] = Z[0] = dZ[0] = null;
        activationFuncs[0] = "";

        b = new float[nLayers + 1];
        db = new float[nLayers + 1];

        cost = new Matrix(layers[nLayers], 1);
    }

    private void initializeParameters() {
        for (int i = 1; i < W.length; i++) {
            W[i].randomize(-1, 1);
        }
    }

    private float relu(float z) {
        return z > 0 ? z : 0;
    }

    private float drelu(float z) {
        return z > 0 ? 1 : 0;
    }

    private float sigmoid(float z) {
        return 1 / (1 + exp(-z));
    }

    private float dsigmoid(float z) {
        return sigmoid(z) * sigmoid(1 - z);
    }

    private Matrix activate(Matrix m, String func) {
        Dimensions dims = m.getDims();
        Matrix res = new Matrix(dims.rows, dims.cols);

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

    private void forwardPropagate() {
        A[0] = X.copy();
        for (int i = 1; i <= nLayers; i++) {
            Z[i] = add(dot(W[i], A[i - 1]), b[i]);
            A[i] = activate(Z[i], activationFuncs[i]);
        }
    }

    private void normalizeOutput() {
        float sum = A[nLayers].sum();
        div(A[nLayers], sum);

        float max = A[nLayers].maximum();
        for (int i = 0; i < layers[nLayers]; i++) {
            if (A[nLayers].getCell(i, 0) == max) {
                outputIndex = i;
                break;
            }
        }
    }

    private void calculateCost() {
        int m = layers[nLayers];
        Matrix AL = A[nLayers];
        cost = div(
            add(dot(Y, log(AL.T)), dot(sub(1, Y), log(sub(1, AL)).T)),
            -m
        );
    }

    private void backPropagate() {
        for (int i = nLayers; i > 0; i--) {
            dZ[i] = mul(dA[i], activate(Z[i], activationFuncs[i]));

            int m = layers[i - 1];
            dW[i] = div(dot(dZ[i], A[i - 1].T), m);
            db[i] = dZ[i].sum() / m;
            dA[i - 1] = dot(W[i].T, dZ[i]);
        }
    }

    private void updateParameters(float alpha) {
        for (int i = 1; i <= nLayers; i++) {
            W[i] = sub(W[i], mul(alpha, dW[i]));
            b[i] = b[i] - alpha * db[i];
        }
    }

    void train(Matrix X, Matrix Y, float alpha) {
        this.X = X;
        this.Y = Y;

        initializeParameters();
        forwardPropagate();
        normalizeOutput();
        calculateCost();
        backPropagate();
        updateParameters(alpha);
    }

    void show(int xpos, int ypos, int hgap, int vgap, int radius) {
        push();

        translate(xpos, ypos);

        ellipseMode(CENTER);
        textAlign(CENTER, CENTER);
        textSize(radius / 1.5);

        // connections
        for (int i = 0; i < nLayers; i++) {
            int x = i;

            for (int m = 0; m < layers[i]; m++) {
                float yM = m + (float) (1 - layers[i]) / 2;

                for (int n = 0; n < layers[i + 1]; n++) {
                    float yN = n + (float) (1 - layers[i + 1]) / 2;

                    stroke(51);
                    if (W[i + 1].getCell(n, m) > 0) {
                        strokeWeight(1);
                    } else {
                        strokeWeight(0);
                    }
                    line(x * hgap, yM * vgap, (x + 1) * hgap, yN * vgap);
                }
            }
        }

        // nodes
        float xMax = X.maximum();
        for (int i = 0; i <= nLayers; i++) {
            int x = i;

            for (int j = 0; j < layers[i]; j++) {
                float yM = j + (float) (1 - layers[i]) / 2;

                noStroke();
                fill(0, 0, 51);
                if (i == 0) {
                    fill(
                        lerpColor(
                            color(0, 0, 0),
                            color(0, 0, 255),
                            X.getCell(j, 0) / xMax
                        )
                    );
                } else if(i == nLayers) {
                    if (j == outputIndex) {
                        fill(0, 191, 0);
                    } else {
                        fill(191, 0, 0);
                    }
                }else {
                    if (A[i].getCell(j, 0) > 0) {
                        fill(0, 63, 0);
                    } else {
                        fill(63, 0, 0);
                    }
                }
                ellipse(x * hgap, yM * vgap, radius * 2, radius * 2);
                fill(255);
                text(j + 1, x * hgap, yM * vgap);
            }
        }

        pop();
    }
}
