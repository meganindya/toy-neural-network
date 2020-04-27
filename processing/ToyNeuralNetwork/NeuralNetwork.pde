class NeuralNetwork {
    private Matrix X, W, b, Y;
    private ArrayList<Integer> nLayers;

    NeuralNetwork(
        Matrix X, Matrix W, Matrix b, Matrix Y, ArrayList<Integer> nLayers
    ) {
        this.X = X;
        this.W = W;
        this.b = b;
        this.Y = Y;
        this.nLayers = nLayers;
    }

    void show(int w, int h) {
        int max = 0;
        for (int i = 0; i < nLayers.size(); i++) {
            if (nLayers.get(i) > max) {
                max = nLayers.get(i);
            }
        }
        int r = 10, vspace = 25, hspace = 100;

        stroke(0);
        fill(127);
        push();

        translate(50, h / 2);

        ellipseMode(CENTER);
        for (int i = 0; i < nLayers.size() - 1; i++) {
            int x = i * hspace;
            for (int m = 0; m < nLayers.get(i); m++) {
                int yM = (m - nLayers.get(i) / 2) * vspace;
                if (nLayers.get(i) % 2 == 0)
                    yM += vspace / 2;
                for (int n = 0; n < nLayers.get(i + 1); n++) {
                    int yN = (n - nLayers.get(i + 1) / 2) * vspace;
                    if (nLayers.get(i + 1) % 2 == 0)
                        yN += vspace / 2;
                    line(x, yM, x + hspace, yN);
                }
                ellipse(x, yM, r * 2, r * 2);
            }
        }
        for (int i = 0; i < nLayers.get(nLayers.size() - 1); i++) {
            int y = (i - nLayers.get(nLayers.size() - 1) / 2) * vspace;
            if (nLayers.get(nLayers.size() - 1) % 2 == 0)
                y += vspace / 2;
            ellipse((nLayers.size() - 1) * hspace, y, r * 2, r * 2);
        }

        pop();
    }
}
