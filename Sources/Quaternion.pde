class Quaternion {
    float w;
    float x;
    float y;
    float z;

    // Par défaut un quaternion identité (aucune rotation)
    Quaternion() {
        this.w = 1.0;
        this.x = 0.0;
        this.y = 0.0;
        this.z = 0.0;
    }

    // Constructeur avec des valeurs spécifiques
    Quaternion(float w, float x, float y, float z) {
        this.w = w;
        this.x = x;
        this.y = y;
        this.z = z;
    }

    // Constructeur depuis une copie
    Quaternion(Quaternion q) {
        this.w = q.w;
        this.x = q.x;
        this.y = q.y;
        this.z = q.z;
    }

    // Construit un quaternion à partir d'un axe et d'un angle (en radians)
    Quaternion(Vecteur3D axe, float angle) {
        Vecteur3D n = new Vecteur3D(axe);
        n.normaliser();
        float demi_angle = angle * 0.5;
        float s = sin(demi_angle);
        this.w = cos(demi_angle);
        this.x = n.x * s;
        this.y = n.y * s;
        this.z = n.z * s;
    }

    // Norme du quaternion 
    float norme_carree() {
        return w * w + x * x + y * y + z * z;
    }

    // Norme du quaternion au carré
    float norme() {
        return sqrt(norme_carree());
    }

    // Normalisation du quaternion
    void normaliser() {
        float n = norme();
        if (n == 0) {
            w = 1.0;
            x = 0.0;
            y = 0.0;
            z = 0.0;
            return;
        }
        w /= n;
        x /= n;
        y /= n;
        z /= n;
    }

    // Conjugaison du quaternion
    Quaternion conjugue() {
        return new Quaternion(w, -x, -y, -z);
    }

    // Addition de deux quaternions
    Quaternion add(Quaternion q) {
        return new Quaternion(w + q.w, x + q.x, y + q.y, z + q.z);
    }

    // Multiplication par un scalaire
    Quaternion mult(float s) {
        return new Quaternion(w * s, x * s, y * s, z * s);
    }

    // Produit de deux quaternions (Produit de Hamilton)
    Quaternion mult(Quaternion q) {
        return new Quaternion(
        w * q.w - x * q.x - y * q.y - z * q.z,
        w * q.x + x * q.w + y * q.z - z * q.y,
        w * q.y - x * q.z + y * q.w + z * q.x,
        w * q.z + x * q.y - y * q.x + z * q.w
        );
    }

    // Met à jour le quaternion en fonction de la vitesse angulaire et du temps écoulé
    void mettre_a_jour_orientation(Vecteur3D velocite_angulaire, float dt) {
        Quaternion qw = new Quaternion(0.0, velocite_angulaire.x, velocite_angulaire.y, velocite_angulaire.z);
        Quaternion delta_q = qw.mult(this).mult(0.5 * dt);
        this.w += delta_q.w;
        this.x += delta_q.x;
        this.y += delta_q.y;
        this.z += delta_q.z;
        this.normaliser();
    }
}