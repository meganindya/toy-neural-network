class Dimensions {
    final int rows, cols;

    Dimensions(int rows, int cols) {
        this.rows = rows;
        this.cols = cols;
    }
}

class Matrix {
    private Dimensions dims;
    private float matrix[][];
    final Matrix T;

    Matrix(int rows, int cols) {
        dims = new Dimensions(rows, cols);
        matrix = new float[rows][cols];
        T = new Matrix(this);
    }

    Matrix(Matrix m) {
        Dimensions dimM = m.getDims();
        dims = new Dimensions(dimM.cols, dimM.rows);
        matrix = new float[dims.rows][dims.cols];
        T = m;
    }

    Dimensions getDims() {
        return dims;
    }

    int[] shape() {
        return new int[] { dims.rows, dims.cols };
    }

    float getCell(int r, int c) {
        return matrix[r][c];
    }

    void setCell(int r, int c, float v) {
        matrix[r][c] = v;
        T.matrix[c][r] = v;
    }

    void randomize(float min, float max) {
        for (int r = 0; r < dims.rows; r++) {
            for (int c = 0; c < dims.cols; c++) {
                setCell(r, c, random(min, max));
            }
        }
    }

    void printMatrix() {
        println("(" + dims.rows + ", " + dims.cols + ")");
        println("---");
        for (int r = 0; r < dims.rows; r++) {
            for (int c = 0; c < dims.cols; c++) {
                print(matrix[r][c] + "\t");
            }
            println();
        }
        println("---");
    }
}

static float unaryOp(float v, String op) {
    if (op.equals("log10"))
        return log(v) / log(10);
    else if (op.equals("log"))
        return log(v);
    return 0;
}

Matrix elemWiseUnaryOp(Matrix m, String op) {
    Dimensions dims = m.getDims();
    Matrix res = new Matrix(dims.rows, dims.cols);

    for (int r = 0; r < dims.rows; r++) {
        for (int c = 0; c < dims.cols; c++) {
            res.setCell(r, c, unaryOp(m.getCell(r, c), op));
        }
    }

    return res;
}

static float binaryOp(float a, float b, char op) {
    if (op == '+')
        return a + b;
    else if (op == '-')
        return a - b;
    else if (op == '*')
        return a * b;
    else if (op == '/')
        return a / b;
    else if (op == '%')
        return a % b;
    return 0;
}

Matrix elemWiseBinaryOp(Matrix m, int v, char op) {
    Dimensions dims = m.getDims();
    Matrix res = new Matrix(dims.rows, dims.cols);

    for (int r = 0; r < dims.rows; r++) {
        for (int c = 0; c < dims.cols; c++) {
            res.setCell(r, c, binaryOp(m.getCell(r, c), v, op));
        }
    }

    return res;
}

Matrix elemWiseBinaryOp(Matrix m, Matrix n, char op) {
    Dimensions dimM = m.getDims();
    Dimensions dimN = n.getDims();

    Matrix res = null;

    if (
        (dimM.rows == dimN.rows && dimM.cols == dimN.cols) ||
        // broadcasting cases
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
                res.setCell(r, c, binaryOp(
                    m.getCell(r, c),
                    n.getCell(min(dimN.rows - 1, r), min(dimN.cols - 1, c)),
                    op
                ));
            }
        }
    }

    return res;
}

Matrix add(Matrix m, int v) {
    return elemWiseBinaryOp(m, v, '+');
}

Matrix add(Matrix m, Matrix n) {
    return elemWiseBinaryOp(m, n, '+');
}

Matrix sub(Matrix m, int v) {
    return elemWiseBinaryOp(m, v, '-');
}

Matrix sub(Matrix m, Matrix n) {
    return elemWiseBinaryOp(m, n, '-');
}

Matrix mul(Matrix m, int v) {
    return elemWiseBinaryOp(m, v, '*');
}

Matrix mul(Matrix m, Matrix n) {
    return elemWiseBinaryOp(m, n, '*');
}

Matrix div(Matrix m, int v) {
    return elemWiseBinaryOp(m, v, '/');
}

Matrix div(Matrix m, Matrix n) {
    return elemWiseBinaryOp(m, n, '/');
}

Matrix mod(Matrix m, int v) {
    return elemWiseBinaryOp(m, v, '%');
}

Matrix mod(Matrix m, Matrix n) {
    return elemWiseBinaryOp(m, n, '%');
}

Matrix log10(Matrix m) {
    return elemWiseUnaryOp(m, "log10");
}

Matrix log(Matrix m) {
    return elemWiseUnaryOp(m, "log");
}
