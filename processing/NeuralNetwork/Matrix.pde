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

    float binaryOp(float a, float b, char op) {
        if (op == '+')
            return a + b;
        else if (op == '-')
            return a - b;
        else if (op == '*')
            return a * b;
        else if (op == '/')
            return a / b;
        return 0;
    }

    Matrix elemWiseBinaryOp(int v, char op) {
        Matrix res = new Matrix(dims.rows, dims.cols);

        for (int r = 0; r < dims.rows; r++) {
            for (int c = 0; c < dims.cols; c++) {
                res.matrix[r][c] = binaryOp(this.matrix[r][c], v, op);
            }
        }

        return res;
    }

    Matrix elemWiseBinaryOp(Matrix n, char op) {
        Dimensions dimM = this.dims;
        Dimensions dimN = n.getDims();

        Matrix res = null;

        if (
            (dimM.rows == dimN.rows && dimM.cols == dimN.cols) ||
            (
                dimM.rows == dimN.rows &&
                (dimM.cols > 1 && dimN.cols == 1)
            ) ||
            (
                dimM.cols == dimN.cols &&
                (dimM.rows > 1 && dimN.rows == 1)
            ) ||
            (dimN.rows == 1 && dimN.cols == 1)
        ) {
            res = new Matrix(
                max(dimM.rows, dimN.rows), max(dimM.cols, dimM.cols)
            );
            Dimensions dimRes = res.getDims();

            for (int r = 0; r < dimRes.rows; r++) {
                for (int c = 0; c < dimRes.cols; c++) {
                    res.matrix[r][c] = binaryOp(
                        this.matrix[r][c],
                        n.matrix[min(dimN.rows - 1, r)][min(dimN.cols - 1, c)],
                        op
                    );
                }
            }
        }

        return res;
    }

    Matrix add(int v) {
        return elemWiseBinaryOp(v, '+');
    }

    Matrix add(Matrix m) {
        return elemWiseBinaryOp(m, '+');
    }

    Matrix sub(int v) {
        return elemWiseBinaryOp(v, '-');
    }

    Matrix sub(Matrix m) {
        return elemWiseBinaryOp(m, '-');
    }

    Matrix mul(int v) {
        return elemWiseBinaryOp(v, '*');
    }

    Matrix mul(Matrix m) {
        return elemWiseBinaryOp(m, '*');
    }

    Matrix div(int v) {
        return elemWiseBinaryOp(v, '/');
    }

    Matrix div(Matrix m) {
        return elemWiseBinaryOp(m, '/');
    }
}
