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

    private Matrix(Matrix m) {
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

    Matrix copy() {
        Matrix res = new Matrix(dims.rows, dims.cols);
        for (int r = 0; r < dims.rows; r++) {
            for (int c = 0; c < dims.cols; c++) {
                res.setCell(r, c, getCell(r, c));
            }
        }
        return res;
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

    float sum() {
        float sum = 0;
        for (int r = 0; r < dims.rows; r++) {
            for (int c = 0; c < dims.cols; c++) {
                sum += getCell(r, c);
            }
        }
        return sum;
    }

    Matrix sum(int axis) {
        Matrix res;

        if (axis == 0) {
            res = new Matrix(1, dims.cols);

            for (int c = 0; c < dims.cols; c++) {
                float sum = 0;
                for (int r = 0; r < dims.rows; r++) {
                    sum += getCell(r, c);
                }
                res.setCell(0, c, sum);
            }

            return res;
        } else {
            res = new Matrix(dims.rows, 1);

            for (int r = 0; r < dims.rows; r++) {
                float sum = 0;
                for (int c = 0; c < dims.cols; c++) {
                    sum += getCell(r, c);
                }
                res.setCell(r, 0, sum);
            }

            return res;
        }
    }

    private float minOrMax(int v) {
        float val = v == 0 ? Float.MAX_VALUE : Float.MIN_VALUE;
        for (int r = 0; r < dims.rows; r++) {
            for (int c = 0; c < dims.cols; c++) {
                val = v == 0 ?
                    min(val, getCell(r, c)) : max(val, getCell(r, c));
            }
        }
        return val;
    }

    private Matrix minOrMax(int v, int axis) {
        Matrix res;

        if (axis == 0) {
            res = new Matrix(1, dims.cols);

            for (int c = 0; c < dims.cols; c++) {
                float val = v == 0 ? Float.MAX_VALUE : Float.MIN_VALUE;
                for (int r = 0; r < dims.rows; r++) {
                    val = v == 0 ?
                        min(val, getCell(r, c)) : max(val, getCell(r, c));
                }
                res.setCell(0, c, val);
            }

            return res;
        } else {
            res = new Matrix(dims.rows, 1);

            for (int r = 0; r < dims.rows; r++) {
                float val = v == 0 ? Float.MAX_VALUE : Float.MIN_VALUE;
                for (int c = 0; c < dims.cols; c++) {
                    val = v == 0 ?
                        min(val, getCell(r, c)) : max(val, getCell(r, c));
                }
                res.setCell(r, 0, val);
            }

            return res;
        }
    }

    float minimum() {
        return minOrMax(0);
    }

    Matrix minimum(int axis) {
        return minOrMax(0, axis);
    }

    float maximum() {
        return minOrMax(1);
    }

    Matrix maximum(int axis) {
        return minOrMax(1, axis);
    }
}

private static float unaryOp(float v, String op) {
    if (op.equals("log10"))
        return log(v) / log(10);
    else if (op.equals("log"))
        return log(v);
    return 0;
}

private Matrix elemWiseUnaryOp(Matrix m, String op) {
    Dimensions dims = m.getDims();
    Matrix res = new Matrix(dims.rows, dims.cols);

    for (int r = 0; r < dims.rows; r++) {
        for (int c = 0; c < dims.cols; c++) {
            res.setCell(r, c, unaryOp(m.getCell(r, c), op));
        }
    }

    return res;
}

private static float binaryOp(float a, float b, char op) {
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

private Matrix elemWiseBinaryOp(Matrix m, float v, char op) {
    Dimensions dims = m.getDims();
    Matrix res = new Matrix(dims.rows, dims.cols);

    for (int r = 0; r < dims.rows; r++) {
        for (int c = 0; c < dims.cols; c++) {
            res.setCell(r, c, binaryOp(m.getCell(r, c), v, op));
        }
    }

    return res;
}

private Matrix elemWiseBinaryOp(float v, Matrix m, char op) {
    Dimensions dims = m.getDims();
    Matrix res = new Matrix(dims.rows, dims.cols);

    for (int r = 0; r < dims.rows; r++) {
        for (int c = 0; c < dims.cols; c++) {
            res.setCell(r, c, binaryOp(v, m.getCell(r, c), op));
        }
    }

    return res;
}

private Matrix elemWiseBinaryOp(Matrix m, Matrix n, char op) {
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

Matrix add(Matrix m, float v) {
    return elemWiseBinaryOp(m, v, '+');
}

Matrix add(float v, Matrix m) {
    return elemWiseBinaryOp(v, m, '+');
}

Matrix add(Matrix m, Matrix n) {
    return elemWiseBinaryOp(m, n, '+');
}

Matrix sub(Matrix m, float v) {
    return elemWiseBinaryOp(m, v, '-');
}

Matrix sub(float v, Matrix m) {
    return elemWiseBinaryOp(v, m, '-');
}

Matrix sub(Matrix m, Matrix n) {
    return elemWiseBinaryOp(m, n, '-');
}

Matrix mul(Matrix m, float v) {
    return elemWiseBinaryOp(m, v, '*');
}

Matrix mul(float v, Matrix m) {
    return elemWiseBinaryOp(v, m, '*');
}

Matrix mul(Matrix m, Matrix n) {
    return elemWiseBinaryOp(m, n, '*');
}

Matrix div(Matrix m, float v) {
    return elemWiseBinaryOp(m, v, '/');
}

Matrix div(float v, Matrix m) {
    return elemWiseBinaryOp(v, m, '/');
}

Matrix div(Matrix m, Matrix n) {
    return elemWiseBinaryOp(m, n, '/');
}

Matrix mod(Matrix m, float v) {
    return elemWiseBinaryOp(m, v, '%');
}

Matrix mod(float v, Matrix m) {
    return elemWiseBinaryOp(v, m, '%');
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

Matrix dot(Matrix m, Matrix n) {
    Dimensions dimM = m.getDims();
    Dimensions dimN = n.getDims();

    Matrix res = null;

    if (dimM.cols == dimN.rows) {
        res = new Matrix(dimM.rows, dimN.cols);

        for (int r = 0; r < dimM.rows; r++) {
            for (int c = 0; c < dimN.cols; c++) {
                float sum = 0;
                for (int k = 0; k < dimM.cols; k++) {
                    sum += m.getCell(r, k) * n.getCell(k, c);
                }
                res.setCell(r, c, sum);
            }
        }
    }

    return res;
}
