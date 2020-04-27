class Matrix {
    class Dimensions {
        final int rows, cols;

        Dimensions(int rows, int cols) {
            this.rows = rows;
            this.cols = cols;
        }
    }

    private Dimensions dims;
    private float matrix[][];

    Matrix(int rows, int cols) {
        dims = new Dimensions(rows, cols);
        this.matrix = new float[rows][cols];
    }

    Dimensions getDims() {
        return dims;
    }

    void randomize(float min, float max) {
        for (int r = 0; r < dims.rows; r++) {
            for (int c = 0; c < dims.cols; c++) {
                matrix[r][c] = random(min, max);
            }
        }
    }

    void printMatrix() {
        for (int r = 0; r < dims.rows; r++) {
            for (int c = 0; c < dims.cols; c++) {
                print(matrix[r][c] + "\t");
            }
            println();
        }
        println("---");
    }
}
