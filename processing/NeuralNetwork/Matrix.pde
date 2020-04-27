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

    Matrix add(Matrix n) {
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
                    res.matrix[r][c] =
                        this.matrix[r][c] +
                        n.matrix[min(dimN.rows - 1, r)][min(dimN.cols - 1, c)];
                }
            }
        }

        return res;
    }

    Matrix add(int v) {
        Matrix res = new Matrix(dims.rows, dims.cols);

        for (int r = 0; r < dims.rows; r++) {
            for (int c = 0; c < dims.cols; c++) {
                res.matrix[r][c] = this.matrix[r][c] + v;
            }
        }
        
        return res;
    }

    Matrix sub(Matrix n) {
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
                    res.matrix[r][c] =
                        this.matrix[r][c] -
                        n.matrix[min(dimN.rows - 1, r)][min(dimN.cols - 1, c)];
                }
            }
        }

        return res;
    }

    Matrix sub(int v) {
        Matrix res = new Matrix(dims.rows, dims.cols);

        for (int r = 0; r < dims.rows; r++) {
            for (int c = 0; c < dims.cols; c++) {
                res.matrix[r][c] = this.matrix[r][c] - v;
            }
        }
        
        return res;
    }

    Matrix mul(Matrix n) {
        Dimensions dimM = this.dims;
        Dimensions dimN = n.getDims();

        Matrix res = null;

        if (
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
                    res.matrix[r][c] =
                        this.matrix[r][c] *
                        n.matrix[min(dimN.rows - 1, r)][min(dimN.cols - 1, c)];
                }
            }
        }

        return res;
    }

    Matrix mul(int v) {
        Matrix res = new Matrix(dims.rows, dims.cols);

        for (int r = 0; r < dims.rows; r++) {
            for (int c = 0; c < dims.cols; c++) {
                res.matrix[r][c] = this.matrix[r][c] * v;
            }
        }
        
        return res;
    }

    Matrix div(Matrix n) {
        Dimensions dimM = this.dims;
        Dimensions dimN = n.getDims();

        Matrix res = null;

        if (
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
                    res.matrix[r][c] =
                        this.matrix[r][c] /
                        n.matrix[min(dimN.rows - 1, r)][min(dimN.cols - 1, c)];
                }
            }
        }

        return res;
    }

    Matrix div(int v) {
        Matrix res = new Matrix(dims.rows, dims.cols);

        for (int r = 0; r < dims.rows; r++) {
            for (int c = 0; c < dims.cols; c++) {
                res.matrix[r][c] = this.matrix[r][c] / v;
            }
        }
        
        return res;
    }
}
