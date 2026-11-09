// Matrice 3x4 (on omet la 4e ligne redondante [0, 0, 0, 1])
class Matrix4 {
    float[] m = new float[12];

    // Constructeur par défaut : matrice identité
    Matrix4() {
        identite();
    }

    // Constructeur avec des valeurs spécifiques
    Matrix4(float m0, float m1, float m2,  float m3,
            float m4, float m5, float m6,  float m7,
            float m8, float m9, float m10, float m11) {
        m[0] = m0; m[1] = m1; m[2]  = m2;  m[3]  = m3;
        m[4] = m4; m[5] = m5; m[6]  = m6;  m[7]  = m7;
        m[8] = m8; m[9] = m9; m[10] = m10; m[11] = m11;
    }

    // Constructeur depuis une copie
    Matrix4(Matrix4 o) {
        for (int i = 0; i < 12; i++) {
            m[i] = o.m[i];
        }
    }

    void identite() {
        for (int i = 0; i < 12; i++){
            m[i] = 0.0;
        }
        m[0] = 1.0;
        m[5] = 1.0;
        m[10] = 1.0;
    }

    // Somme de deux matrices 3x4
    Matrix4 add(Matrix4 o) {
        Matrix4 res = new Matrix4();
        for (int i = 0; i < 12; i++) {
        res.m[i] = this.m[i] + o.m[i];
        }
        return res;
    }

    // Produit de deux matrices 3x4
    Matrix4 mult(Matrix4 o) {
        Matrix4 res = new Matrix4();
        res.m[0] = m[0]*o.m[0] + m[1]*o.m[4] + m[2]*o.m[8];
        res.m[1] = m[0]*o.m[1] + m[1]*o.m[5] + m[2]*o.m[9];
        res.m[2] = m[0]*o.m[2] + m[1]*o.m[6] + m[2]*o.m[10];
        res.m[3] = m[0]*o.m[3] + m[1]*o.m[7] + m[2]*o.m[11] + m[3];

        res.m[4] = m[4]*o.m[0] + m[5]*o.m[4] + m[6]*o.m[8];
        res.m[5] = m[4]*o.m[1] + m[5]*o.m[5] + m[6]*o.m[9];
        res.m[6] = m[4]*o.m[2] + m[5]*o.m[6] + m[6]*o.m[10];
        res.m[7] = m[4]*o.m[3] + m[5]*o.m[7] + m[6]*o.m[11] + m[7];

        res.m[8]  = m[8]*o.m[0] + m[9]*o.m[4] + m[10]*o.m[8];
        res.m[9]  = m[8]*o.m[1] + m[9]*o.m[5] + m[10]*o.m[9];
        res.m[10] = m[8]*o.m[2] + m[9]*o.m[6] + m[10]*o.m[10];
        res.m[11] = m[8]*o.m[3] + m[9]*o.m[7] + m[10]*o.m[11] + m[11];
        return res;
    }

    // Transforme un vecteur POSITION [x, y, z, 1] -> translation + rotation
    Vecteur3D transformer_position(Vecteur3D p) {
        return new Vecteur3D(
        p.x * m[0] + p.y * m[1] + p.z * m[2]  + m[3],
        p.x * m[4] + p.y * m[5] + p.z * m[6]  + m[7],
        p.x * m[8] + p.y * m[9] + p.z * m[10] + m[11]
        );
    }

    // Transforme un vecteur DIRECTION [x, y, z, 0] -> rotation seulement
    Vecteur3D transformer_direction(Vecteur3D d) {
        return new Vecteur3D(
        d.x * m[0] + d.y * m[1] + d.z * m[2],
        d.x * m[4] + d.y * m[5] + d.z * m[6],
        d.x * m[8] + d.y * m[9] + d.z * m[10]
        );
    }

    // Déterminant de la matrice 3x4
    float determinant() {
        return m[0] * (m[5] * m[10] - m[6] * m[9])
            - m[1] * (m[4] * m[10] - m[6] * m[8])
            + m[2] * (m[4] * m[9]  - m[5] * m[8]);
    }

    // Inverse de la matrice 3x4
    Matrix4 inverser() {
        float det = determinant();
        if (abs(det) < 0.000001){
            return new Matrix4();
        }

        float inv_det = 1.0 / det;
        Matrix4 res = new Matrix4();

        res.m[0]  = (m[5] * m[10] - m[6] * m[9]) * inv_det;
        res.m[1]  = (m[2] * m[9]  - m[1] * m[10]) * inv_det;
        res.m[2]  = (m[1] * m[6]  - m[2] * m[5]) * inv_det;

        res.m[4]  = (m[6] * m[8]  - m[4] * m[10]) * inv_det;
        res.m[5]  = (m[0] * m[10] - m[2] * m[8]) * inv_det;
        res.m[6]  = (m[2] * m[4]  - m[0] * m[6]) * inv_det;

        res.m[8]  = (m[4] * m[9]  - m[5] * m[8]) * inv_det;
        res.m[9]  = (m[1] * m[8]  - m[0] * m[9]) * inv_det;
        res.m[10] = (m[0] * m[5]  - m[1] * m[4]) * inv_det;

        // Calcul de la translation inverse
        res.m[3]  = -(res.m[0] * m[3] + res.m[1] * m[7] + res.m[2] * m[11]);
        res.m[7]  = -(res.m[4] * m[3] + res.m[5] * m[7] + res.m[6] * m[11]);
        res.m[11] = -(res.m[8] * m[3] + res.m[9] * m[7] + res.m[10] * m[11]);

        return res;
    }

    // Construit une matrice 3x4 à partir d'une orientation (quaternion) et d'une position (vecteur)
    void depuis_orientation_et_position(Quaternion q, Vecteur3D pos) {
        float w = q.w, x = q.x, y = q.y, z = q.z;
        m[0] = 1.0 - 2.0 * (y * y + z * z);
        m[1] = 2.0 * (x * y + z * w);
        m[2] = 2.0 * (x * z - y * w);
        m[3] = pos.x;

        m[4] = 2.0 * (x * y - z * w);
        m[5] = 1.0 - 2.0 * (x * x + z * z);
        m[6] = 2.0 * (y * z + x * w);
        m[7] = pos.y;

        m[8]  = 2.0 * (x * z + y * w);
        m[9]  = 2.0 * (y * z - x * w);
        m[10] = 1.0 - 2.0 * (x * x + y * y);
        m[11] = pos.z;
    }

    // Applique la matrice 3x4 dans Processing (pour les transformations OpenGL)
    void appliquer_processing() {
        applyMatrix(
        m[0], m[1], m[2],  m[3],
        m[4], m[5], m[6],  m[7],
        m[8], m[9], m[10], m[11],
        0.0,  0.0,  0.0,   1.0
        );
    }
}