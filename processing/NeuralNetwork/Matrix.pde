class Matrix {
    class Dimensions {
        final int rows, cols;

        Dimensions(int rows, int cols) {
            this.rows = rows;
            this.cols = cols;
        }
    }

    private Dimensions dims;
    private int matrix[][];

    Matrix(int rows, int cols) {
        dims = new Dimensions(rows, cols);
        this.matrix = new int[rows][cols];
    }

    Dimensions getDims() {
        return dims;
    }

    void randomize(int min, int max) {
        for (int r = 0; r < dims.rows; r++) {
            for (int c = 0; c < dims.cols; c++) {
                matrix[r][c] = floor(random(min, max));
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
