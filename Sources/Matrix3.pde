class Matrix3 {
    float[] m = new float[9];

    // Constructeur par défaut : matrice identité
    Matrix3() {
        identite();
    }

    // Constructeur avec des valeurs spécifiques
    Matrix3(float m0, float m1, float m2,
            float m3, float m4, float m5,
            float m6, float m7, float m8) {
        m[0] = m0; m[1] = m1; m[2] = m2;
        m[3] = m3; m[4] = m4; m[5] = m5;
        m[6] = m6; m[7] = m7; m[8] = m8;
    }

    // Constructeur depuis une copie
    Matrix3(Matrix3 o) {
        for (int i = 0; i < 9; i++) {
            m[i] = o.m[i];
        }
    }

    void identite() {
        for (int i = 0; i < 9; i++) {
            m[i] = 0.0;
        }
        m[0] = 1.0;
        m[4] = 1.0; 
        m[8] = 1.0;
    }

    // Somme de deux matrices 3x3
    Matrix3 add(Matrix3 o) {
        return new Matrix3(
        m[0] + o.m[0], m[1] + o.m[1], m[2] + o.m[2],
        m[3] + o.m[3], m[4] + o.m[4], m[5] + o.m[5],
        m[6] + o.m[6], m[7] + o.m[7], m[8] + o.m[8]
        );
    }

    // Multiplication par un scalaire
    Matrix3 mult(float s) {
        return new Matrix3(
        m[0] * s, m[1] * s, m[2] * s,
        m[3] * s, m[4] * s, m[5] * s,
        m[6] * s, m[7] * s, m[8] * s
        );
    }

    // Multiplication d'une matrice 3x3 par un vecteur 3D
    Vecteur3D mult(Vecteur3D v) {
    return new Vecteur3D(
        v.x * m[0] + v.y * m[1] + v.z * m[2],
        v.x * m[3] + v.y * m[4] + v.z * m[5],
        v.x * m[6] + v.y * m[7] + v.z * m[8]
        );
    }

    // Produit de deux matrices 3x3
    Matrix3 mult(Matrix3 o) {
        return new Matrix3(
        m[0]*o.m[0] + m[1]*o.m[3] + m[2]*o.m[6],
        m[0]*o.m[1] + m[1]*o.m[4] + m[2]*o.m[7],
        m[0]*o.m[2] + m[1]*o.m[5] + m[2]*o.m[8],

        m[3]*o.m[0] + m[4]*o.m[3] + m[5]*o.m[6],
        m[3]*o.m[1] + m[4]*o.m[4] + m[5]*o.m[7],
        m[3]*o.m[2] + m[4]*o.m[5] + m[5]*o.m[8],

        m[6]*o.m[0] + m[7]*o.m[3] + m[8]*o.m[6],
        m[6]*o.m[1] + m[7]*o.m[4] + m[8]*o.m[7],
        m[6]*o.m[2] + m[7]*o.m[5] + m[8]*o.m[8]
        );
    }

    // Transpose de la matrice 3x3
    Matrix3 transposer() {
        return new Matrix3(
        m[0], m[3], m[6],
        m[1], m[4], m[7],
        m[2], m[5], m[8]
        );
    }

    // Déterminant de la matrice 3x3
    float determinant() {
        return m[0] * (m[4] * m[8] - m[5] * m[7])
            - m[1] * (m[3] * m[8] - m[5] * m[6])
            + m[2] * (m[3] * m[7] - m[4] * m[6]);
    }

    // Inverse de la matrice 3x3
    Matrix3 inverser() {
        float det = determinant();
        if (abs(det) < 0.000001){
            return new Matrix3();
        }

        float inv_det = 1.0 / det;
        return new Matrix3(
        (m[4] * m[8] - m[5] * m[7]) * inv_det,
        (m[2] * m[7] - m[1] * m[8]) * inv_det,
        (m[1] * m[5] - m[2] * m[4]) * inv_det,

        (m[5] * m[6] - m[3] * m[8]) * inv_det,
        (m[0] * m[8] - m[2] * m[6]) * inv_det,
        (m[2] * m[3] - m[0] * m[5]) * inv_det,

        (m[3] * m[7] - m[4] * m[6]) * inv_det,
        (m[1] * m[6] - m[0] * m[7]) * inv_det,
        (m[0] * m[4] - m[1] * m[3]) * inv_det
        );
    }

    // Construit une matrice 3x3 à partir d'une orientation (quaternion)
    void depuis_quaternion(Quaternion q) {
        float w = q.w, x = q.x, y = q.y, z = q.z;
        m[0] = 1.0 - 2.0 * (y * y + z * z);
        m[1] = 2.0 * (x * y + z * w);
        m[2] = 2.0 * (x * z - y * w);

        m[3] = 2.0 * (x * y - z * w);
        m[4] = 1.0 - 2.0 * (x * x + z * z);
        m[5] = 2.0 * (y * z + x * w);

        m[6] = 2.0 * (x * z + y * w);
        m[7] = 2.0 * (y * z - x * w);
        m[8] = 1.0 - 2.0 * (x * x + y * y);
    }
}